require "application_system_test_case"

class GroupsTest < ApplicationSystemTestCase
  setup do
    @group = groups(:default)
  end

  test "visiting the index" do
    visit groups_url
    # assert_selector "p", text: "group #1"
  end

  test "should create group" do # TODO: this isn't implemented
    # visit groups_url
    # click_on "New group"

    # fill_in "Content", with: @group.content
    # click_on "Create Group"

    # assert_text "Group was successfully created"
    # click_on "Back"
  end

  test "should update Group" do # TODO: this isn't implemented
    # visit group_url(@group)
    # click_on "Edit this group", match: :first

    # fill_in "Content", with: @group.content
    # click_on "Update Group"

    # assert_text "Group was successfully updated"
    # click_on "Back"
  end

  test "should destroy Group" do # TODO: this isn't implemented
    # visit group_url(@group)
    # click_on "Destroy this group", match: :first

    # assert_text "Group was successfully destroyed"
  end
end
