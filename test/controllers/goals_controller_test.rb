require 'test_helper'

class GoalsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get goals_create_url
    assert_response :success
  end

end
