require "test_helper"

class ThoughtsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @thought = thoughts(:thought_1)
  end

  test "should get index" do
    get thoughts_url
    assert_response :success
  end

  test "should get new" do
    get new_thought_url
    assert_response :success
  end

  test "should create thought" do
    assert_difference("Thought.count") do
      post thoughts_url, params: { thought: { content: @thought.content, user_id: @thought.user_id } }
    end

    actual = thought_url(Thought.find_by(content: @thought.content, user_id: @thought.user_id))

    assert_redirected_to actual
  end

  test "shouldn't create thought" do
    assert_no_difference("Thought.count") do
      post thoughts_url, params: { thought: { user_id: "garbage" } }
    end

    assert_response :unprocessable_entity
  end

  test "should show thought" do
    get thought_url(@thought)
    assert_response :success
  end

  test "should get edit" do
    get edit_thought_url(@thought)
    assert_response :success
  end

  test "should update thought" do
    patch thought_url(@thought), params: { thought: { content: @thought.content, user_id: @thought.user_id } }
    assert_redirected_to thought_url(@thought)
  end

  test "shouldn't update thought" do
    patch thought_url(@thought), params: { thought: { user_id: "garbage" } }
    assert_response :unprocessable_entity
  end

  test "should destroy thought" do
    assert_difference("Thought.count", -1) do
      delete thought_url(@thought)
    end

    assert_redirected_to thoughts_url
  end
end
