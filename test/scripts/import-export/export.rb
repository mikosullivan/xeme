require 'helper'
require 'structverse'

# Tests exporting a Xeme to JSON.

class XemeTestImportExport < Minitest::Test
  # slurp in environment
  def env_slurp
    return JSON.parse(local_file('./environment.json'))
  end
  
  # slurp in expected hash
  def expected
    rv = JSON.parse(local_file('./expected.json'))
    uuid_to_placeholders rv
    return rv
  end
  
  # set UUIDs as placeholders
  def uuid_to_placeholders(hsh)
    Structverse.walk(hsh) do |el|
      if el.is_a?(Hash) and el['uuid']
        el['uuid'] = 'uuid'
      end
    end
  end
  
  # export json, then compare to xeme
  def test_export
    Timecop.freeze(env_slurp['timestamp']) do
      xeme = Xeme.new
      xeme.init_meta
      xeme.error.init_meta
      xeme.success.init_meta
      xeme.warning.init_meta
      xeme.note.init_meta
      xeme.promise.init_meta
      
      actual = JSON.parse(xeme.to_json)
      uuid_to_placeholders actual
      assert_equal expected, actual
    end
  end
  
  # import
  def test_import
    xeme = Xeme.import(expected)
    assert_instance_of Xeme, xeme
    
    # convenience
    nested = xeme.nested
    assert_equal 5, nested.length
    
    # all nested should be xemes
    nested.each do |child|
      assert child.is_a?(Xeme)
    end
    
    # check classes of nested xemes
    assert_instance_of Xeme, nested[0]
    assert_instance_of Xeme, nested[1]
    assert_instance_of Xeme::Warning, nested[2]
    assert_instance_of Xeme::Note, nested[3]
    assert_instance_of Xeme::Promise, nested[4]
  end
end