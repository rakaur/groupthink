require "test_helper"

class StreamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stream = streams(:one)
  end

  test "should get index" do
    get streams_url
    assert_response :success
  end

  test "should get new" do
    get new_stream_url
    assert_response :success
  end

  test "should create stream" do
    assert_difference("Stream.count") do
      post streams_url, params: { stream: { content: "test" } }
    end

    assert_redirected_to stream_url(Stream.last)
  end

  test "shouldn't create stream" do
    assert_no_difference("Stream.count") do
      post streams_url, params: { stream: { created_ago: "garbage" } }
    end

    assert_response :unprocessable_entity
  end

  test "shouldn't show stream" do
    get stream_url(@stream)
    assert_redirected_to streams_url
  end

  test "should get edit" do
    get edit_stream_url(@stream)
    assert_response :success
  end

  test "should update stream" do
    patch stream_url(@stream), params: { stream: { content: "test" } }
    assert_redirected_to edit_stream_url(@stream)
  end

  test "shouldn't update stream" do
    patch stream_url(@stream), params: { stream: { created_ago: "garbage" } }
    assert_response :unprocessable_entity
  end

  test "should destroy stream" do
    assert_difference("Stream.count", -1) do
      delete stream_url(@stream)
    end

    assert_redirected_to streams_url
  end
end
