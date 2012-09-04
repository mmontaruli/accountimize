require "spec_helper"

describe UserMailer do
  before(:each) do
    @user = create(:user)
    @user.generate_token(:password_reset_token)
    @user.save!
  end
  describe "password_reset" do
    #user = create(:user)
    #let(:user) { mock_model(User, :email => 'lucas@email.com') }
    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do

      mail.subject.should eq("Password reset")
      #mail.to.should eq(["to@example.org"])
      mail.to.should == [@user.email]
      #mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      #mail.body.encoded.should match("Hi")
      mail.body.encoded.should match("To reset your password, click the URL below.")
    end
  end

end
