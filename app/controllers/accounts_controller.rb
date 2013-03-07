class AccountsController < ApplicationController

  # skip_before_filter :authorize, :only => [:index, :new, :create]
  skip_before_filter :authorize, :only => [:new, :create]
  # before_filter :restrict_access, :except => [:index, :new, :create, :show]
  before_filter :restrict_access, :except => [:new, :create, :show]

  # def index
  #   @accounts = Account.all

  #   respond_to do |format|
  #     format.html
  #     format.json { render json: @accounts }
  #   end
  # end

  def show
    @account = Account.find_by_subdomain!(request.subdomain)
    @inner_navigation = true

    respond_to do |format|
      format.html
      format.json { render json: @account }
    end
  end

  def new
    @account = Account.new
    @unique_account_master_name = "ACCOUNT_MASTER_" + Time.now.strftime("%Y%m%d%H%M%S")
    client = @account.clients.build
    client.users.build

    respond_to do |format|
      format.html
      format.json { render json: @account }
    end
  end

  def edit
    @account = Account.find(params[:id])
    @account_master = @account.clients.find(:all, :conditions => {:is_account_master => true})
    @inner_navigation = true
  end

  def create
    @account = Account.new(params[:account])
    @unique_account_master_name = "ACCOUNT_MASTER_" + Time.now.strftime("%Y%m%d%H%M%S")

    respond_to do |format|
      if @account.save
        #format.html { redirect_to log_in_url(:subdomain => @account.subdomain), :flash => {notice: 'Account was successfully created.', :status => 'success'} }
        user = @account.clients.find(:first, :conditions => {:is_account_master => true}).users.first
        AccountMailer.welcome_email(user).deliver
        format.html { redirect_to log_in_url(:subdomain => @account.subdomain)}
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      #format.html { redirect_to accounts_url(:subdomain => false) }
      format.html { redirect_to site_url(:subdomain => 'www') }
      format.json { head :ok }
    end
  end
end
