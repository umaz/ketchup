require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get detail" do
    get :detail
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
