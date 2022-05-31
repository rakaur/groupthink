require "application_system_test_case"

class StreamsTest < ApplicationSystemTestCase
  setup do
    @stream = streams(:one)
  end

  test "visiting the index" do
    visit streams_url
    assert_selector "p", text: "stream #1"
  end

  test "should create stream" do # TODO: this isn't implemented
    # visit streams_url
    # click_on "New stream"

    # fill_in "Content", with: @stream.content
    # click_on "Create Stream"

    # assert_text "Stream was successfully created"
    # click_on "Back"
  end

  test "should update Stream" do # TODO: this isn't implemented
    # visit stream_url(@stream)
    # click_on "Edit this stream", match: :first

    # fill_in "Content", with: @stream.content
    # click_on "Update Stream"

    # assert_text "Stream was successfully updated"
    # click_on "Back"
  end

  test "should destroy Stream" do # TODO: this isn't implemented
    # visit stream_url(@stream)
    # click_on "Destroy this stream", match: :first

    # assert_text "Stream was successfully destroyed"
  end
end
