require 'test_helper'

class Users::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get sprints" do
    get users_pages_sprints_url
    assert_response :success
  end

end
