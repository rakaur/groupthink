require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#default_stream returns Stream # 1" do
    expected = Stream.find(1)
    actual = User.all.sample.default_stream
    assert_equal expected, actual
  end
end
