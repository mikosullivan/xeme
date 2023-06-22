require 'helper'

# Tests Xeme#nest

class XemeTestTypes < Minitest::Test
  # success
  def test_success
    xeme = Xeme.new
    assert xeme.success.success?
  end
  
  # failure
  def test_failure
    xeme = Xeme.new
    assert_instance_of FalseClass, xeme.failure.success?
  end
  
  # warning
  def test_warning
    xeme = Xeme.new
    assert_instance_of Xeme::Warning, xeme.warning
  end
  
  # note
  def test_note
    xeme = Xeme.new
    assert_instance_of Xeme::Note, xeme.note
  end
  
  # promise
  def test_promise
    xeme = Xeme.new
    assert_instance_of Xeme::Promise, xeme.promise
  end
end