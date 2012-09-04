class Message < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :subject, :user_id
end
