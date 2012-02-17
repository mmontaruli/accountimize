require 'test_helper'

class EstimatesControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:one)
    @estimate = estimates(:one)
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

    assert_redirected_to account_estimate_path(@account, assigns(:estimate))
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
    assert_redirected_to account_estimate_path(@account, assigns(:estimate))
  end

  test "should destroy estimate" do
    assert_difference('Estimate.count', -1) do
      delete :destroy, account_id: @account, id: @estimate.to_param
    end

    assert_redirected_to account_estimates_path(@account)
  end
  
  test "should generate three line items" do
    get :new, account_id: @account
    assert_select "table.line_items tr.edit", 3
  end
  
  test "estimate number should not be empty" do
    get :new, account_id: @account
    assert_equal 1000002, assigns(:estimate).number
  end
  
end
