require 'helper'

# Tests the Xeme class itself.

class XemeTest < Minitest::Test
  # test properties of the Xeme class itself
  def test_class
    assert Xeme::DEFAULT.empty?
    assert Xeme::DEFAULT.frozen?
    assert_instance_of Hash, Xeme::DEFAULT
    assert_equal ['type'], Xeme::PROHIBIT_ASSIGN
    refute Xeme::ADVISORY
  end
end