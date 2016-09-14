require 'test_helper'

class SprintsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sprints_new_url
    assert_response :success
  end

  test "should get create" do
    get sprints_create_url
    assert_response :success
  end

end
