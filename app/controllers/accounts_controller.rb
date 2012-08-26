class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.json

  skip_before_filter :authorize, :only => [:index, :new, :create]
  before_filter :restrict_access, :except => [:index, :new, :create, :show]

  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    #@account = Account.find(params[:id])
    @account = Account.find_by_subdomain!(request.subdomain)
    @inner_navigation = true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.json
  def new
    @account = Account.new
    @unique_account_master_name = "ACCOUNT_MASTER_" + Time.now.strftime("%Y%m%d%H%M%S")
    #@account.clients.build
    client = @account.clients.build
    client.users.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
    @account_master = @account.clients.find(:all, :conditions => {:is_account_master => true})
    @inner_navigation = true
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(params[:account])
    @unique_account_master_name = "ACCOUNT_MASTER_" + Time.now.strftime("%Y%m%d%H%M%S")

    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_path, :flash => {notice: 'Account was successfully created.', :status => 'success'} }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to @account, :flash => {notice: 'Account was successfully updated.', :status => 'success'} }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url(:subdomain => false) }
      format.json { head :ok }
    end
  end
end
