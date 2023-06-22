require 'helper'

# Tests Xeme#nest

class XemeTestCreate < Minitest::Test
  # nested should return an empty array
  def test_nested
    assert_instance_of Array, Xeme.new.nested
    assert Array, Xeme.new.nested.empty?
  end
  
  # get back a xeme back by default
  def test_nest_default
    xeme = Xeme.new
    
    child = xeme.nest do |x|
      assert_instance_of xeme.class, x
    end
    
    assert_instance_of xeme.class, child
  end
  
  # get back a xeme with explicit type class
  def test_nest_explicit_class
    xeme = Xeme.new
    
    child = xeme.nest(Xeme::Warning) do |x|
      assert_instance_of Xeme::Warning, x
    end
    
    assert_instance_of Xeme::Warning, child
  end
  
  # nest an existing Xeme
  def test_nest_xeme
    xeme = Xeme.new
    child = Xeme.new
    
    returned = xeme.nest(child) do |x|
      assert child.equal?(x)
    end
    
    assert child.equal?(returned)
  end
  
  # attempt to call #nest with an invalid type value
  def test_nest_invalid_type
    xeme = Xeme.new
    
    err = assert_raises(Xeme::Exception::InvalidNestType) do
      xeme.nest false
    end
    
    assert_instance_of FalseClass, err.detail
  end
  
  # attempt to call #nest with an invalid class
  def test_nest_invalid_class
    xeme = Xeme.new
    
    err = assert_raises(Xeme::Exception::InvalidNestClass) do
      xeme.nest Hash
    end
    
    assert_equal Hash, err.detail
  end
end