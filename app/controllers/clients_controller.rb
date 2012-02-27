class ClientsController < ApplicationController
  # GET /clients
  # GET /clients.json
  
  before_filter :get_account
  before_filter :inner_navigation
  def index
    #@clients = Client.all
    #@clients = @account.clients.all
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
        format.html { redirect_to account_client_path(@account,@client), :flash => {notice: 'Client was successfully created.', :status => 'success'} }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to account_client_path(@account,@client), :flash => {notice: 'Client was successfully updated.', :status => 'success'} }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to account_clients_url }
      format.json { head :ok }
    end
  end
  
  # GET /clients/1/client_address
  def client_address
    @client = @account.clients.find(params[:id])
    render partial: 'client_address', layout: nil
  end

end
