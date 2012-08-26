When /^I log in$/ do
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I am logged in$/ do
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I would like to log out$/ do
end

Given /^I am a vendor$/ do
  if @user
    @user.client.is_account_master = true
    @user.client.save
  end
end
