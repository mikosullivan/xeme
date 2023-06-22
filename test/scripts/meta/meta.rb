require 'helper'

# Tests Xeme#meta param, Xeme#init_meta, Xeme#init_timestamp, Xeme#init_uuid

class XemeTestMeta < Minitest::Test
  # Xeme#meta
  def test_meta
    xeme = Xeme.new
    assert_nil xeme['meta']
    xeme.meta
    assert_instance_of Hash, xeme['meta']
  end
  
  # init_uuid
  def test_init_uuid
    xeme = Xeme.new
    xeme.init_uuid
  end
  
  # init_timestamp
  def test_init_timestamp
    xeme = Xeme.new
    xeme.init_timestamp
    assert_instance_of DateTime, xeme['meta']['timestamp']
  end
  
  # init_meta
  def test_init_meta
    xeme = Xeme.new
    xeme.init_meta
    assert_instance_of DateTime, xeme['meta']['timestamp']
    assert_instance_of String, xeme['meta']['uuid']
  end
  
  # accessors
  def test_accessors
    xeme = Xeme.new
    assert_nil xeme.timestamp
    assert_nil xeme.uuid
    
    xeme = Xeme.new
    xeme.init_meta
    assert_instance_of DateTime, xeme.timestamp
    assert_instance_of String, xeme.uuid
    
    xeme = Xeme.new
    xeme.id = 'whatever'
    assert_equal 'whatever', xeme.id
  end
end