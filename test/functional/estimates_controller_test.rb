require 'test_helper'

class EstimatesControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:lorem)
    @estimate = estimates(:lorem_one)
    @user = users(:lorem_vendor)
    @request.host = "#{@account.subdomain}.myapp.local"
    session[:user_id] = @user.id
  end

  test "should get index" do
    get :index, account_id: @account
    assert_response :success
    assert_not_nil assigns(:estimates)
  end

  test "should get new" do
    get :new, account_id: @account
    assert_response :success
  end

  test "should create estimate" do
    assert_difference('Estimate.count') do
      post :create, account_id: @account, estimate: @estimate.attributes
    end

    assert_redirected_to estimate_path(assigns(:estimate))
  end

  test "should show estimate" do
    get :show, account_id: @account, id: @estimate.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, account_id: @account, id: @estimate.to_param
    assert_response :success
  end

  test "should update estimate" do
    put :update, account_id: @account, id: @estimate.to_param, estimate: @estimate.attributes
    assert_redirected_to estimate_path(assigns(:estimate))
  end

  test "should destroy estimate" do
    assert_difference('Estimate.count', -1) do
      delete :destroy, account_id: @account, id: @estimate.to_param
    end

    assert_redirected_to estimates_path
  end

  test "should generate three line items" do
    get :new, account_id: @account
    #assert_select "table.line_items tr.edit", 3
    assert_select "table.line_items tr.line_item", 3
  end

  test "estimate number should not be empty" do
    get :new, account_id: @account
    assert_equal 1000002, assigns(:estimate).number
  end

end
