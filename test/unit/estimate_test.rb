require 'test_helper'

class EstimateTest < ActiveSupport::TestCase

  fixtures :accounts, :clients, :estimates
  
  test "estimate date must not be empty" do
    estimate = clients(:two_one).estimates.build
    assert estimate.invalid?
    assert estimate.errors[:date].any?
  end
  
  test "estimate number must be greater than or equal to 1" do
    estimate = clients(:two_one).estimates.build(:date => "2011-10-19")
    estimate.number = -1
    assert estimate.invalid?
    
    estimate.number = 0
    assert estimate.invalid?
    
    estimate.number = "a"
    assert estimate.invalid?
    
    estimate.number = 1
    assert estimate.valid?
  end

  test "Estimate#default_number is per-account" do
    assert_equal 1000002, accounts(:one).estimates.default_number
    assert_equal 1000000, accounts(:empty).estimates.default_number
  end

  test "estimate number default is present" do
    data = {date: '2011-10-19'}
    estimate = Estimate.new data.merge({client_id: clients(:one_one).id})
    assert_equal 1000002, estimate.number
    estimate.save!
    estimate = Estimate.new data.merge({client_id: clients(:two_one).id})
    assert_equal 1000000, estimate.number
  end
end
