class Message < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :subject, :user_id
  after_save :send_message_email

  def send_message_email
  	MessageMailer.email_message(self).deliver
  end
end
