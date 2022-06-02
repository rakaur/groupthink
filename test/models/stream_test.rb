require "test_helper"

class StreamTest < ActiveSupport::TestCase
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
