class MessagesController < ApplicationController
  before_filter :inner_navigation

  def index
  	@messages = current_user.messages.find(:all)

  	respond_to do |format|
  	  format.html
  	end
  end

  def show
  	@message = Message.find(params[:id])

  	respond_to do |format|
  	  format.html
  	end
  end

  def destroy
  	@message = Message.find(params[:id])
  	@message.destroy

  	respond_to do |format|
  	  format.html {redirect_to messages_url}
  	end
  end
end
