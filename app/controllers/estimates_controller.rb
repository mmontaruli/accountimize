class EstimatesController < ApplicationController
  before_filter :get_account
  before_filter :inner_navigation
  before_filter :restrict_access, :except => [:index, :show, :edit, :update]
  before_filter :restrict_estimate_access, :except => [:index]
  before_filter :restrict_account_access, :except => [:index, :new, :create]

  def index
    if signed_in_client.is_account_master
      @estimates = @account.estimates.find(:all, :include => :client)
    else
      @estimates = signed_in_client.estimates.find(:all, :include => :client)
    end

    respond_to do |format|
      format.html
      format.json { render json: @estimates }
    end
  end

  def show
    begin
      @estimate = Estimate.find(params[:id])
      @client = Client.find_by_id(@estimate.client_id)
    rescue
      logger.error "Attempt to access invalid estimate #{params[:id]}"
      redirect_to estimates_url, :flash => {:notice => 'Invalid estimate', :status => 'error'}
    else
      respond_to do |format|
        format.html
        format.json { render json: @estimate }
      end
    end
  end

  def new
    @estimate = Estimate.new(number: @account.estimates.default_number)
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(params[:client_id])
    @estimate.client_id = @client.id if @client
    3.times do
      line_item = @estimate.line_items.build
    end
    respond_to do |format|
      format.html
      format.json { render json: @estimate }
    end
  end

  def edit
    @estimate = Estimate.find(params[:id])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(@estimate.client_id)
    if @estimate.is_accepted
      respond_to do |format|
        format.html { redirect_to estimate_path(@estimate), :flash => {notice: 'Estimate has been accepted and cannot be edited.', :status => 'secondary'} }
      end
    end

  end

  def create
    @estimate = Estimate.new(params[:estimate])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      if @estimate.save
        @estimate.client.users.each do |user|
          Message.create(user_id: user.id, subject: "New Estimate ##{@estimate.number}", body: "You have a new estimate. Please visit #{estimate_url(@estimate, subdomain: @estimate.client.account.subdomain)} to view.")
        end
        format.html { redirect_to estimate_path(@estimate), :flash => {notice: 'Estimate was successfully created.', :status => 'success'} }
        format.json { render json: @estimate, status: :created, location: @estimate }
      else
        format.html { render action: "new" }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @estimate = Estimate.find(params[:id])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    # method needs to be run before save
    @negotiate_lines_added = negotiate_lines_added

    respond_to do |format|
      if @estimate.update_attributes(params[:estimate])

      # send message to counter party if a new negotiate line was added
      if @negotiate_lines_added
        counter_party.users.each do |user|
          Message.create(user_id: user.id, subject: "New negotiation on estimate ##{@estimate.number}", body: "One of your estimates was recently counter-offered. Please visit #{estimate_url(@estimate, subdomain: @estimate.client.account.subdomain)} to review.")
        end
      end

        format.html { redirect_to estimate_path(@estimate), :flash => {notice: 'Estimate was successfully updated.', :status => 'success'} }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

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

    # this will test if a new negotiate_line was added
    def negotiate_lines_added
      @estimate.line_items.each do |line_item|
        unless line_item.negotiate_lines.empty?
          return true if line_item.negotiate_lines.last.line_item_id_changed?
        end
        #  return true
        #end
      end
    end

    # need to find out who the counter party is
    def counter_party
      if @estimate.client == signed_in_client
        other_party = @account.clients.find(:first, :conditions => {:is_account_master => true})
      else
        other_party = @estimate.client
      end
      other_party
    end

end
