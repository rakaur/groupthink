require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#data_turbo_false" do
    expected = { data: { turbo: false } }
    actual = data_turbo_false
    assert_equal expected, actual
  end

  test "#turbo_false" do
    expected = { turbo: false }
    actual = turbo_false
    assert_equal expected, actual
  end
end
