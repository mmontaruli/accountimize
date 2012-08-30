class EstimatesController < ApplicationController
  # GET /estimates
  # GET /estimates.json
  before_filter :get_account
  before_filter :inner_navigation
  before_filter :restrict_access, :except => [:index, :show, :edit, :update]
  before_filter :restrict_estimate_access, :except => [:index]
  before_filter :restrict_account_access, :except => [:index, :new, :create]

  def index
    #@estimates = Estimate.all
    #@estimates = Estimate.find(:all, :include => :client)
    if signed_in_client.is_account_master
      @estimates = @account.estimates.find(:all, :include => :client)
    else
      @estimates = signed_in_client.estimates.find(:all, :include => :client)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @estimates }
    end
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
    begin
      @estimate = Estimate.find(params[:id])
      @client = Client.find_by_id(@estimate.client_id)
    rescue
      logger.error "Attempt to access invalid estimate #{params[:id]}"
      redirect_to estimates_url, :flash => {:notice => 'Invalid estimate', :status => 'error'}
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @estimate }
      end
    end
  end

  # GET /estimates/new
  # GET /estimates/new.json
  def new
    @estimate = Estimate.new(number: @account.estimates.default_number)
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(params[:client_id])
    @estimate.client_id = @client.id if @client
    3.times do
      line_item = @estimate.line_items.build
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @estimate }
    end
  end

  # GET /estimates/1/edit
  def edit
    @estimate = Estimate.find(params[:id])
    #@clients = Client.all
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(@estimate.client_id)
    #@disable_form = !signed_in_client.is_account_master
    #respond_to do |format|
    if @estimate.is_accepted
      respond_to do |format|
        format.html { redirect_to estimate_path(@estimate), :flash => {notice: 'Estimate has been accepted and cannot be edited.', :status => 'secondary'} }
      end
    end
    #end

  end

  # POST /estimates
  # POST /estimates.json
  def create
    @estimate = Estimate.new(params[:estimate])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      if @estimate.save
        format.html { redirect_to estimate_path(@estimate), :flash => {notice: 'Estimate was successfully created.', :status => 'success'} }
        format.json { render json: @estimate, status: :created, location: @estimate }
      else
        format.html { render action: "new" }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /estimates/1
  # PUT /estimates/1.json
  def update
    @estimate = Estimate.find(params[:id])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      if @estimate.update_attributes(params[:estimate])
        #format.html { redirect_to @estimate, notice: 'Estimate was successfully updated.' }
        format.html { redirect_to estimate_path(@estimate), :flash => {notice: 'Estimate was successfully updated.', :status => 'success'} }
        format.json { head :ok }
        #format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate = Estimate.find(params[:id])
    @estimate.destroy

    respond_to do |format|
      format.html { redirect_to estimates_url }
      format.json { head :ok }
    end
  end

  private

    def restrict_estimate_access
      unless signed_in_client.is_account_master
        @estimate = Estimate.find(params[:id])
        unless signed_in_client.id == @estimate.client_id
          redirect_to estimates_path
        end
      end
      if params[:client_id]
        @target_account = Client.find(params[:client_id]).account
        if @target_account != @account
          redirect_to site_url
        end
      end
    end

    def restrict_account_access
      @estimate = Estimate.find_by_id(params[:id])
      @estimate_client = Client.find_by_id(@estimate.client_id)
      @estimate_account = Account.find_by_id(@estimate_client.account_id)
      if @estimate_account != @account
        redirect_to site_url
      end
    end

end
