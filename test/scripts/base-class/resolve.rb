require 'helper'

# Tests resolving a single xeme. Not really much to test here because resolving
# a single xeme should always result in the same success value as it started
# with.

class XemeTestClass < Minitest::Test
  def test_resolve
    # default setting
    xeme = Xeme.new()
    xeme.resolve
    assert_nil xeme.success?
    
    # explicit success
    xeme = Xeme.new()
    xeme.try_succeed
    xeme.resolve
    assert xeme.success?
    
    # explicit fail
    xeme = Xeme.new()
    xeme.fail
    xeme.resolve
    assert_instance_of FalseClass, xeme.success?
    
    # explicit nil
    xeme = Xeme.new()
    xeme['success'] = nil
    xeme.resolve
    assert_nil xeme.success?
  end
end