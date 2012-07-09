require 'test_helper'

class InvoiceSchedulesControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:lorem)
    @estimate = estimates(:lorem_one)
    @user = users(:lorem_vendor)
    @request.host = "#{@account.subdomain}.myapp.local"
    session[:user_id] = @user.id
    @invoice_schedule = invoice_schedules(:lorem_one)
    @data_estimate = estimates(:lorem_two)
  end

  test "should redirect index to estimate index" do
    get :index, estimate_id: @estimate
    assert_redirected_to estimates_path
  end

  test "should get new" do
    get :new, estimate_id: @estimate
    assert_response :success
  end

  test "should create invoice_schedule" do
    assert_difference('InvoiceSchedule.count') do
      post :create, :estimate_id => @data_estimate.id,
                    :invoice_schedule => {
                      :invoice_milestones_attributes => {
                        "0" =>{:estimate_percentage => 100, :description => "test"}
                      }
                    }
    end
    assert_redirected_to invoice_schedule_path(assigns(:invoice_schedule))
  end

  test "should show invoice_schedule" do
    get :show, id: @invoice_schedule.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, account_id: @account, id: @invoice_schedule.to_param
    assert_response :success
  end

  test "should update invoice_schedule" do
    put :update, id: @invoice_schedule.to_param, invoice_schedule: @invoice_schedule.attributes
    assert_redirected_to invoice_schedule_path(assigns(:invoice_schedule))
  end

  test "should destroy invoice_schedule" do
    assert_difference('InvoiceSchedule.count', -1) do
      delete :destroy, account_id: @account, id: @invoice_schedule.to_param
    end

    assert_redirected_to estimate_path
  end
end
