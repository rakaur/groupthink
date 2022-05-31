require "application_system_test_case"

class ThoughtsTest < ApplicationSystemTestCase
  setup do
    @thought = thoughts(:thought_1)
  end

  test "visiting the index" do
    visit thoughts_url
    assert_selector "h1", text: "Thoughts"
  end

  test "should create thought" do
    visit thoughts_url
    click_on "New thought"

    fill_in "Content", with: @thought.content
    fill_in "User", with: @thought.user_id
    click_on "Create Thought"

    assert_text "Thought was successfully created"
    click_on "Back"
  end

  test "should update Thought" do
    visit thought_url(@thought)
    click_on "Edit this thought", match: :first

    fill_in "Content", with: @thought.content
    fill_in "User", with: @thought.user_id
    click_on "Update Thought"

    assert_text "Thought was successfully updated"
    click_on "Back"
  end

  test "should destroy Thought" do
    visit thought_url(@thought)
    click_on "Destroy this thought", match: :first

    assert_text "Thought was successfully destroyed"
  end
end
