FactoryGirl.define do

  factory :account do
  	sequence(:name) { |n| "name#{n}" }
  	subdomain { |u| u.name.gsub(/\s+/, "").downcase }
  end

  factory :client do
    sequence(:name) { |n| "name#{n}" }
    address_street_1 "123 Main Street"
    address_street_2 "Suite 100"
    address_city "Long Beach"
    address_state "New York"
    address_zip "12345"
    country "United States"
    is_account_master false
    account
  end

  factory :user do
  	sequence(:email) { |n| "foo#{n}@example.com" }
  	password "foobar"
  	password_confirmation { |u| u.password }
  	client
  end

  factory :estimate do
    sequence(:number) { |n| 100+n }
    date Date.today
    client
  end

  factory :line_item do
    number 100
    name "Services"
    quantity 1
    unit_price 100
    is_enabled true
    estimate
  end

end