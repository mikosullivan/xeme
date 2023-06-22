require 'helper'

# Tests promise xemes

class XemeTestPromise < Minitest::Test
  # test Xeme::Promise class
  def test_class
    assert_equal({'type'=>'promise'}, Xeme::Promise::DEFAULT)
    assert Xeme::Promise::DEFAULT.frozen?
    assert_instance_of Hash, Xeme::Promise::DEFAULT
    assert_equal ['type'], Xeme::Promise::PROHIBIT_ASSIGN
    assert Xeme::Promise::PROHIBIT_ASSIGN.frozen?
    refute Xeme::Promise::ADVISORY
  end
  
  # prohibit assignment of success without supplanted
  def test_prohibit_success
    promise = Xeme::Promise.new
    
    assert_raises(Xeme::Exception::CannotSucceedPromiseUnlessSupplanted) do
      promise['success'] = true
    end
  end
  
  # allow assignment of success with supplanted
  def test_allow_success
    xeme = Xeme::Promise.new
    xeme['supplanted']=true
    xeme['success'] = true
  end
  
  # cannot succeed in try_succeed if supplanted is falsy
  def prohibit_try_succeed
    promise = Xeme::Promise.new
    promise.nest['success'] = true
    assert_nil promise.try_succeed
  end
  
  # can succeed in try_succeed if supplanted is truthy
  def allow_try_succeed
    promise = Xeme::Promise.new
    promise.nest['success'] = true
    promise['supplanted'] = true
    assert promise.try_succeed
  end
  
  # by default, resolving should set parent xeme to nil
  def test_parent_resolve_nil
    parent = Xeme.new
    parent.promise
    parent.try_succeed
    assert_nil parent.success?
  end
  
  # parent can succeed if promise is supplanted
  def test_parent_resolve_true
    parent = Xeme.new
    parent.promise['supplanted'] = true
    parent.try_succeed
    assert parent.success?
  end
end