require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get detail" do
    get :detail
    assert_response :success
  end

  test "should get entry" do
    get :entry
    assert_response :success
  end

  test "should get reqest" do
    get :reqest
    assert_response :success
  end

end
