require 'test_helper'

class InvoiceSchedulesControllerTest < ActionController::TestCase
  setup do
    @invoice_schedule = invoice_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoice_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice_schedule" do
    assert_difference('InvoiceSchedule.count') do
      post :create, invoice_schedule: @invoice_schedule.attributes
    end

    assert_redirected_to invoice_schedule_path(assigns(:invoice_schedule))
  end

  test "should show invoice_schedule" do
    get :show, id: @invoice_schedule.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice_schedule.to_param
    assert_response :success
  end

  test "should update invoice_schedule" do
    put :update, id: @invoice_schedule.to_param, invoice_schedule: @invoice_schedule.attributes
    assert_redirected_to invoice_schedule_path(assigns(:invoice_schedule))
  end

  test "should destroy invoice_schedule" do
    assert_difference('InvoiceSchedule.count', -1) do
      delete :destroy, id: @invoice_schedule.to_param
    end

    assert_redirected_to invoice_schedules_path
  end
end
