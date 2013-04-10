require "spec_helper"

describe EstimateMailer do
  before(:each) do
  	# @user = create(:user)
    client = create(:client, users_attributes: [attributes_for(:user)])
    @user = client.users.first
  	@estimate = create(:estimate, client_id: @user.client_id, send_to_contact: @user.id)
  	@new_pw= @user.generate_valid_password
  end

  describe "first_estimate_email" do
  	let(:mail) { EstimateMailer.first_estimate_email(@estimate, @user, @new_pw) }

  		it "renders the headers" do
			mail.subject.should eql("#{@estimate.client.account.name} just sent you an estimate via Accountimize")
			mail.to.should eql([@user.email])
			mail.from.should eql(["no-reply@accountimize.com"])
		end

		it "renders the body" do
			mail.body.encoded.should match("You just received an estimate from #{@estimate.client.account.name}")
		end

  end
end
