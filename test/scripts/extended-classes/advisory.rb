require 'helper'

# Tests warning and note xemes

class XemeTestWarning < Minitest::Test
  def classes
    return [Xeme::Warning, Xeme::Note]
  end
  
  # test classes
  def test_class
    # defaults
    assert_equal({'type'=>'note'}, Xeme::Note::DEFAULT)
    assert_equal({'type'=>'warning'}, Xeme::Warning::DEFAULT)
    
    classes.each do |clss|
      assert clss::DEFAULT.frozen?
      assert_instance_of Hash, clss::DEFAULT
      assert_equal ['success', 'type'], clss::PROHIBIT_ASSIGN
      assert clss::PROHIBIT_ASSIGN.frozen?
      assert clss::ADVISORY
    end
  end
  
  # test prohibiting assignment of success
  def test_assign_success
    classes.each do |clss|
      xeme = clss.new
      
      err = assert_raises(Xeme::Exception::CannotAssignKey) do
        xeme['success'] = true
      end
      
      assert_equal 'success', err.detail
    end
  end
  
  # test prohibiting assignment of type
  def test_assign_type
    classes.each do |clss|
      xeme = clss.new
      
      err = assert_raises(Xeme::Exception::CannotAssignKey) do
        xeme['type'] = 'whatever'
      end
      
      assert_equal 'type', err.detail
    end
  end
  
  # try_succeed should fail
  def test_try_succeed
    classes.each do |clss|
      xeme = clss.new
      refute xeme.try_succeed
    end
  end
  
  # revolving should have no affect on the parent xeme
  def test_resolve
    classes.each do |clss|
      xeme = Xeme.new
      xeme.try_succeed
      assert xeme.success?
      xeme.nest clss
      xeme.resolve
      assert_instance_of TrueClass, xeme['success']
    end
  end
  
  # success? should true in parent xeme
  def test_success
    classes.each do |clss|
      xeme = Xeme.new
      xeme.try_succeed
      assert xeme.success?
      xeme.nest clss
      assert_instance_of TrueClass, xeme.success?
    end
  end
  
  # cannot nest non-advisory xeme
  def test_non_advisory
    classes.each do |clss|
      xeme = clss.new
      
      err = assert_raises(Xeme::Exception::CannotNestNonadvisory) do
        xeme.nest Xeme
      end
      
      assert_equal Xeme, err.detail
    end
  end
end