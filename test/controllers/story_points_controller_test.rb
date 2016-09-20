require 'test_helper'

class StoryPointsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get story_points_edit_url
    assert_response :success
  end

end
