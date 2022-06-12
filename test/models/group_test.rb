require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "#thoughts no filters" do
    @group = groups(:none)
    expected = Thought.none
    actual = @group.thoughts

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts one filter" do
    @group = groups(:default)
    @filter = filters(:default)
    expected = Thought.where(created_at: @filter.compare_interval.ago .. Time.current)
    actual = @group.thoughts

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts multiple filters" do
    @group = groups(:multiple)
    @filter_one = filters(:created_range)
    @filter_two = filters(:random_user)

    expected = Thought.where(created_at: @filter_one.compare_daterange)
                      .where(user: @filter_two.compare_integer)

    actual = @group.thoughts

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end
end
