require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#default_group returns Group #1" do
    expected = Group.find(1)
    actual = User.all.sample.default_group
    assert_equal expected, actual
  end
end
