require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:lorem_one)
    @account = accounts(:lorem)
    @user = users(:lorem_vendor)
    @data = @client.attributes.merge({name: 'unique name'})
    @request.host = "#{@account.subdomain}.myapp.local"
    session[:user_id] = @user.id
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
      post :create, client: @data
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, account_id: @account.to_param, id: @client.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, account_id: @account, id: @client.to_param
    assert_response :success
  end

  test "should update client" do
    put :update, id: @client.to_param, client: @client.attributes
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client.to_param
    end

    assert_redirected_to clients_path
  end
end
