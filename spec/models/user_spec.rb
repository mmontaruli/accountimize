require 'spec_helper'

describe User do
	it "should not allow insecure passwords" do
		User.new.should have(2).error_on(:password)
	end
	it "should not allow a non-email address" do
		User.new.should have(2).error_on(:email)
	end
end
