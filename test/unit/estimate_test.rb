require 'test_helper'

class EstimateTest < ActiveSupport::TestCase
  
  test "estimate attributes must not be empty" do
    estimate = Estimate.new
    assert estimate.invalid?
    assert estimate.errors[:date].any?
    assert estimate.errors[:number].any?
  end
  
  test "estimate number must be greater than 1" do
    estimate = Estimate.new(:date     => "2011-10-19")
    estimate.number = -1
    assert estimate.invalid?
    
    estimate.number = 0
    assert estimate.invalid?
    
    estimate.number = "a"
    assert estimate.invalid?
    
    estimate.number = 1
    assert estimate.valid?
  end
    
end
