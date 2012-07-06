require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:lorem)
    @client = clients(:lorem_one)
    @user = users(:lorem_vendor)
    @request.host = "#{@account.subdomain}.myapp.local"
    session[:user_id] = @user.id
  end

  test "should get new" do
    #get :new, account_id: @account
    get :new, client_id: @client
    assert_response :success
  end

end
