require "test_helper"

class FilterTest < ActiveSupport::TestCase
  test "validates filter_attribute" do
    assert_raises(ActiveRecord::RecordInvalid) { Filter.create! }
  end

  test "validates comparison_type" do
    assert_raises(ActiveRecord::RecordInvalid) { Filter.create!(filter_attribute: "test") }
  end

  test "validates comparison_type + compare_" do
    @filter = filters(:default)
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_interval: nil) }
  end

  test "validates compare_date" do
    @filter = filters(:default)
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_date: 1234) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_date: /re/) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_date: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_date: [69]) }
    assert_nothing_raised { @filter.update!(compare_date: Time.current) }
    assert_nothing_raised { @filter.update!(compare_date: Date.current) }
  end

  test "validates compare_daterange" do
    @filter = filters(:default)
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: 1234) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: 1 .. 2) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: /re/) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: [69]) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: Time.current) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_daterange: Date.current) }
    assert_nothing_raised { @filter.update!(compare_daterange: 1.year.ago .. 1.hour.ago) }
  end

  test "validates compare_interval" do
    @filter = filters(:default)
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_interval: 1234) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_interval: /re/) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_interval: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_interval: [69]) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_interval: Time.current) }
    assert_nothing_raised { @filter.update!(compare_interval: 1.hour) }
  end

  test "validates compare_string_array" do
    @filter = filters(:string_array)
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_string_array: 1234) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_string_array: /re/) }
    assert_raises(ActiveRecord::RecordInvalid) { @filter.update!(compare_string_array: Time.current) }
  end

  test "#query for default filter" do
    @filter = filters(:default)
    expected = Thought.where(created_at: @filter.compare_interval.ago .. Time.current)
    actual = @filter.query

    assert_kind_of expected.class, actual
    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#query for created" do
    @filter = filters(:created)
    date = @filter.compare_date
    expected = Thought.where(created_at: date.beginning_of_day .. date.end_of_day)
    actual = @filter.query

    assert_equal expected.size, actual.size
    assert_equal thoughts(:created), actual.first

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#query for created_ago" do
    @filter = filters(:last_year)
    expected = Thought.where(created_at: @filter.compare_interval.ago .. Time.current)
    actual = @filter.query

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#query does created_range" do
    @filter = filters(:created_range)
    expected = Thought.where(created_at: @filter.compare_daterange)
    actual = @filter.query

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#query does user" do
    @filter = filters(:random_user)
    expected = Thought.where(user: @filter.compare_integer)
    actual = @filter.query

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#query does users" do
    @filter = filters(:random_users)
    expected = Thought.where(user: @filter.compare_integer_array)
    actual = @filter.query

    assert_equal expected.size, actual.size

    expected.size.times { |i| assert_equal expected[i], actual[i] }
  end
end
