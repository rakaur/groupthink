require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    get new_group_url
    assert_response :success
  end

  test "should create group" do
    assert_difference("Group.count") do
      post groups_url, params: { group: { content: "test" } }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "shouldn't create group" do
    assert_no_difference("Group.count") do
      post groups_url, params: { group: { created_ago: "garbage" } }
    end

    assert_response :unprocessable_entity
  end

  test "shouldn't show group" do
    get group_url(@group)
    assert_redirected_to groups_url
  end

  test "should get edit" do
    get edit_group_url(@group)
    assert_response :success
  end

  test "should update group" do
    patch group_url(@group), params: { group: { content: "test" } }
    assert_redirected_to edit_group_url(@group)
  end

  test "shouldn't update group" do
    patch group_url(@group), params: { group: { created_ago: "garbage" } }
    assert_response :unprocessable_entity
  end

  test "should destroy group" do
    assert_difference("Group.count", -1) do
      delete group_url(@group)
    end

    assert_redirected_to groups_url
  end
end
