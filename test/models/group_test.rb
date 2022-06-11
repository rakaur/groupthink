require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "validates (all|any)_tags" do
    @group = Group.new
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(all_tags: {}) }
    assert_nothing_raised { @group.update!(all_tags: %w[ one two three ]) }
  end

  test "validates author_ids" do
    @group = Group.new
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(author_ids: 1) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(author_ids: [1]) }
    assert_nothing_raised { @group.update!(author_ids: [users(:admin).id]) }
  end

  test "validates (created|updated)" do
    @group = Group.new
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created: 1234) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created: /re/) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created: [69]) }
    assert_nothing_raised { @group.update!(created: Time.current) }
  end

  test "validates (created|updated)_ago" do
    @group = Group.new
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created_ago: {}) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created_ago: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created_ago: [69]) }
    assert_nothing_raised { @group.update!(created_ago: 1.hour) }
  end

  test "validates (created|updated)_range" do
    @group = Group.new
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created_range: 1 .. 2) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created_range: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(created_range: [69]) }
    assert_nothing_raised { @group.update!(created_range: 1.year.ago .. 1.hour.ago) }
  end

  test "validates limit" do
    @group = Group.new
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(limit: {}) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(limit: [-1]) }
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(limit: "hi") }

    # Limit by itself does not a filter make
    assert_raises(ActiveRecord::RecordInvalid) { @group.update!(limit: 10) }

    assert_nothing_raised { @group.update!(content: "test", limit: 10) }
  end

  # test "#thoughts does all_tags" do
  #   assert true
  # end

  # test "#thoughts does any_tags" do
  #   assert true
  # end

  test "#thoughts does author_id" do
    @group = groups(:author_id)
    expected = Thought.where(user: @group.author_ids)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does author_ids" do
    @group = groups(:author_ids)
    expected = Thought.where(user: @group.author_ids)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  # test "#thoughts does content" do
  #   assert true
  # end

  test "#thoughts does created" do
    @group = groups(:created)
    expected = Thought.where(created_at: @group.created)

    actual = @group.thoughts

    assert_equal expected.count, actual.count
    assert_equal thoughts(:created), actual.first

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does created_ago" do
    @group = groups(:created_ago)
    expected = Thought.where(created_at: @group.created_ago.ago .. Time.current)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does created_range" do
    @group = groups(:created_range)
    expected = Thought.where(created_at: @group.created_range)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does limit" do
    @group = groups(:limit)
    expected = Thought.all.limit(5)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does param limit" do
    @group = groups(:one)
    expected = Thought.where(created_at: @group.created_ago.ago .. Time.current).limit(5)
    actual = @group.thoughts(5)

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does updated" do
    @group = groups(:updated)
    expected = Thought.where(updated_at: @group.updated)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does updated_ago" do
    @group = groups(:updated_ago)
    expected = Thought.where(updated_at: @group.updated_ago.ago .. Time.current)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does updated_range" do
    @group = groups(:updated_range)
    expected = Thought.where(updated_at: @group.updated_range)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end

  test "#thoughts does multiple" do
    @group = groups(:multiple)
    expected = Thought.where(user: @group.author_ids, updated_at: @group.updated_range)

    actual = @group.thoughts

    assert_equal expected.count, actual.count

    expected.count.times { |i| assert_equal expected[i], actual[i] }
  end
end
