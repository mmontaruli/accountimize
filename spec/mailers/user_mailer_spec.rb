require "spec_helper"

describe UserMailer do
  before(:each) do
    @user = create(:user)
    @user.generate_token(:password_reset_token)
    @user.save!
  end
  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do

      mail.subject.should eq("Password reset")
      mail.to.should == [@user.email]
      mail.from.should == ["no-reply@accountimize.com"]
    end

    it "renders the body" do
      mail.body.encoded.should match("To reset your password, click the URL below.")
    end
  end

end
