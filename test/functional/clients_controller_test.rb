require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one_one)
    @account = accounts(:one)
    @data = @client.attributes.merge({name: 'unique name'})
  end

  test "should get index" do
    get :index, account_id: @account
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new, account_id: @account
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, account_id: @account, client: @data
    end

    assert_redirected_to account_client_path(@account, assigns(:client))
  end

  test "should show client" do
    get :show, account_id: @account, id: @client.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, account_id: @account, id: @client.to_param
    assert_response :success
  end

  test "should update client" do
    put :update, account_id: @account, id: @client.to_param, client: @client.attributes
    assert_redirected_to account_client_path(@account, assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, account_id: @account, id: @client.to_param
    end

    assert_redirected_to account_clients_path(@account)
  end
end
