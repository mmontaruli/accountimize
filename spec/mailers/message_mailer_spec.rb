require "spec_helper"

describe MessageMailer do
  before(:each) do
    client = create(:client, users_attributes: [attributes_for(:user)])
    user = client.users.first
    @message = create(:message, user_id: user.id)
  end
  describe "email_message" do
    let(:mail) { MessageMailer.email_message(@message) }

    it "renders the headers" do
      mail.subject.should eq(@message.subject)
      mail.to.should eq([@message.user.email])
      mail.from.should eq(["no-reply@accountimize.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@message.body)
    end
  end

end
