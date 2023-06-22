require 'helper'

# Tests errors

class XemeTestError < Minitest::Test
  # fail method
  def test_fail
    xeme = Xeme.new
    xeme.fail
    assert_instance_of FalseClass, xeme['success']
    assert_instance_of FalseClass, xeme.success?
  end
  
  # try_succeed should fail
  def test_try_succeed
    xeme = Xeme.new
    xeme.fail
    refute xeme.try_succeed
  end
  
  # resolving should set parent xeme to failure
  def test_resolve
    xeme = Xeme.new
    xeme.nest.fail
    xeme.resolve
    assert_instance_of FalseClass, xeme['success']
    assert_instance_of FalseClass, xeme.success?
  end
end