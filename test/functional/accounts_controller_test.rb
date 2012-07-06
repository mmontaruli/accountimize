require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:lorem)
    @client = clients(:lorem_am)
    @user = users(:lorem_vendor)
    @data_account = @account.attributes.merge({name: 'unique name', subdomain: 'uniquesubdomain'})
    @data_client = @client.attributes.merge({name: 'very unique name'})
    @data_user = @user.attributes.merge({email: 'unique email'})
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, account: @data_account, client: @data_client, user: @data_user
    end

    assert_redirected_to accounts_path
    assert_equal 'Account was successfully created.', flash[:notice]
  end

  test "should show account" do
    session[:user_id] = @user.id
    @request.host = "#{@account.subdomain}.myapp.local"
    get :show, id: @account.to_param
    assert_response :success
  end

  test "should get edit" do
    session[:user_id] = @user.id
    get :edit, id: @account.to_param
    assert_response :success
  end

  test "should update account" do
    session[:user_id] = @user.id
    put :update, id: @account.to_param, account: @account.attributes
    assert_redirected_to account_path(assigns(:account))
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      session[:user_id] = @user.id
      delete :destroy, id: @account.to_param
    end

    assert_redirected_to accounts_path
  end
end
