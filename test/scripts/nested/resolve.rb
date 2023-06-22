require 'helper'

# Test resolving a xeme based on its descendents. These tests check a total of
# nine possible combinations: child initial success is true, nil, or false,
# parent starts with the same three possibilities.

class XemeTestResolve < Minitest::Test
  #-----------------------------------------------------------------------------
  # parent success
  #
  def test_success_success
    xeme = Xeme.new
    xeme['success'] = true
    child = xeme.nest()
    child['success'] = true
    
    xeme.resolve
    assert xeme.success?
    assert child.success?
    
    xeme.try_succeed
    assert xeme.success?
    assert child.success?
  end
  
  def test_success_nil
    xeme = Xeme.new
    xeme['success'] = true
    child = xeme.nest()
    child['success'] = nil
    
    xeme.resolve
    assert_nil xeme.success?
    assert_nil child.success?
    
    xeme.try_succeed
    assert xeme.success?
    assert child.success?
  end
  
  def test_success_false
    xeme = Xeme.new
    xeme['success'] = true
    child = xeme.nest()
    child['success'] = false
    
    xeme.resolve
    assert_instance_of FalseClass, xeme.success?
    assert_instance_of FalseClass, child.success?
    
    xeme.try_succeed
    assert_instance_of FalseClass, xeme.success?
    assert_instance_of FalseClass, child.success?
  end
  #
  # parent success
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # parent nil
  #
  def test_nil_success
    xeme = Xeme.new
    xeme['success'] = nil
    child = xeme.nest()
    child['success'] = true
    
    xeme.resolve
    assert_nil xeme.success?
    assert child.success?
    
    xeme.try_succeed
    assert xeme.success?
    assert child.success?
  end
  
  def test_nil_nil
    xeme = Xeme.new
    xeme['success'] = nil
    child = xeme.nest()
    child['success'] = nil
    
    xeme.resolve
    assert_nil xeme.success?
    assert_nil child.success?
    
    xeme.try_succeed
    assert xeme.success?
    assert child.success?
  end
  
  def test_nil_false
    xeme = Xeme.new
    xeme['success'] = nil
    child = xeme.nest()
    child['success'] = false
    
    xeme.resolve
    assert_instance_of FalseClass, xeme.success?
    assert_instance_of FalseClass, child.success?
    
    xeme.try_succeed
    assert_instance_of FalseClass, xeme.success?
    assert_instance_of FalseClass, child.success?
  end
  #
  # parent nil
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # parent false
  #
  def test_false_success
    xeme = Xeme.new
    xeme['success'] = false
    child = xeme.nest()
    child['success'] = true
    
    xeme.resolve
    assert_instance_of FalseClass, xeme.success?
    assert child.success?
    
    xeme.try_succeed
    assert_instance_of FalseClass, xeme.success?
    assert child.success?
  end
  
  def test_false_nil
    xeme = Xeme.new
    xeme['success'] = false
    child = xeme.nest()
    child['success'] = nil
    
    xeme.resolve
    assert_instance_of FalseClass, xeme.success?
    assert_nil child.success?
    
    xeme.try_succeed
    assert_instance_of FalseClass, xeme.success?
    assert child.success?
  end
  
  def test_false_false
    xeme = Xeme.new
    xeme['success'] = false
    child = xeme.nest()
    child['success'] = false
    
    xeme.resolve
    assert_instance_of FalseClass, xeme.success?
    assert_instance_of FalseClass, child.success?
    
    xeme.try_succeed
    assert_instance_of FalseClass, xeme.success?
    assert_instance_of FalseClass, child.success?
  end
  #
  # parent false
  #-----------------------------------------------------------------------------
end