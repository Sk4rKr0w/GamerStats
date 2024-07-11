require "test_helper"

class SquadsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get squads_new_url
    assert_response :success
  end

  test "should get create" do
    get squads_create_url
    assert_response :success
  end

  test "should get show" do
    get squads_show_url
    assert_response :success
  end
end
