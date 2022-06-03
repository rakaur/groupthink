require "test_helper"

class StreamTest < ActiveSupport::TestCase
  test "validates (all|any)_tags" do
    @stream = Stream.new
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(all_tags: {}) }
    assert_nothing_raised { @stream.update!(all_tags: %w[ one two three ]) }
  end

  test "validates author_ids" do
    @stream = Stream.new
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(author_ids: 1) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(author_ids: [1]) }
    assert_nothing_raised { @stream.update!(author_ids: [users(:admin).id]) }
  end

  test "validates (created|updated)" do
    @stream = Stream.new
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created: 1234) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created: /re/) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created: [69]) }
    assert_nothing_raised { @stream.update!(created: Time.current) }
  end

  test "validates (created|updated)_ago" do
    @stream = Stream.new
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created_ago: {}) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created_ago: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created_ago: [69]) }
    assert_nothing_raised { @stream.update!(created_ago: 1.hour) }
  end

  test "validates (created|updated)_range" do
    @stream = Stream.new
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created_range: 1 .. 2) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created_range: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(created_range: [69]) }
    assert_nothing_raised { @stream.update!(created_range: 1.year.ago .. 1.hour.ago) }
  end

  test "validates limit" do
    @stream = Stream.new
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(limit: {}) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(limit: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @stream.update!(limit: "hi") }
    assert_nothing_raised { @stream.update!(limit: 10) }
  end

  # test "#thoughts does all_tags" do
  #   assert true
  # end

  # test "#thoughts does any_tags" do
  #   assert true
  # end

  test "#thoughts does author_id" do
    @stream = streams(:author_id)
    expected = Thought.where(user: @stream.author_ids)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does author_ids" do
    @stream = streams(:author_ids)
    expected = Thought.where(user: @stream.author_ids)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  # test "#thoughts does content" do
  #   assert true
  # end

  test "#thoughts does created" do
    @stream = streams(:created)
    expected = Thought.where(created_at: @stream.created)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count
    assert_equal thoughts(:created), actual.first

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does created_ago" do
    @stream = streams(:created_ago)
    expected = Thought.where(created_at: @stream.created_ago.ago .. Time.current)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does created_range" do
    @stream = streams(:created_range)
    expected = Thought.where(created_at: @stream.created_range)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does limit" do
    @stream = streams(:limit)
    expected = Thought.all.limit(5)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does updated" do
    @stream = streams(:updated)
    expected = Thought.where(updated_at: @stream.updated)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does updated_ago" do
    @stream = streams(:updated_ago)
    expected = Thought.where(updated_at: @stream.updated_ago.ago .. Time.current)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does updated_range" do
    @stream = streams(:updated_range)
    expected = Thought.where(updated_at: @stream.updated_range)

    actual = @stream.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end
end
