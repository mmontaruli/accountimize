class ClientsController < ApplicationController
  before_filter :get_account
  before_filter :inner_navigation
  before_filter :restrict_access
  before_filter :restrict_account_access, :except => [:index, :new, :create]

  def index
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      format.html
      format.json { render json: @clients }
    end
  end

  def show
    @client = Client.find(params[:id])
    @users = @client.users.find(:all)

    respond_to do |format|
      format.html
      format.json { render json: @client }
    end
  end

  def new
    @client = Client.new

    respond_to do |format|
      format.html
      format.json { render json: @client }
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_path(@client), :flash => {notice: 'Client was successfully created.', :status => 'success'} }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to client_path(@client), :flash => {notice: 'Client was successfully updated.', :status => 'success'} }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :ok }
    end
  end

  def client_address
    @client = @account.clients.find(params[:id])
    render partial: 'client_address', layout: nil
  end

  def user_select
    @client = @account.clients.find(params[:id])
    render partial: 'user_select', layout: nil
  end


  private

  def restrict_account_access
    @client = Client.find(params[:id])
    @client_account = Account.find_by_id(@client.account_id)
    if @client_account != @account
      redirect_to site_url
    end
  end

end
