require 'helper'

# Tests setting success.

class XemeTest < Minitest::Test
  # test default properties of a new xeme
  def test_initialize
    xeme = Xeme.new()
    assert_nil xeme['success']
    assert_nil xeme.success?
  end
  
  # test for valid success values
  def test_valid_success
    xeme = Xeme.new()
    xeme['success'] = true
    xeme['success'] = false
    xeme['success'] = nil
  end
  
  # test try_succeed
  def test_try_succeed
    # success never set
    xeme = Xeme.new
    assert xeme.try_succeed
    
    # explicit success
    xeme = Xeme.new
    xeme['success'] = true
    assert xeme.try_succeed
    
    # set success element to false
    xeme = Xeme.new
    xeme['success'] = false
    refute xeme.try_succeed
    
    # fail method
    xeme = Xeme.new
    xeme.fail
    refute xeme.try_succeed
    
    # explicit nil
    xeme = Xeme.new
    xeme['success'] = nil
    assert xeme.try_succeed
  end
end