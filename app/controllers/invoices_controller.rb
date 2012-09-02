class InvoicesController < ApplicationController
  before_filter :get_account
  before_filter :inner_navigation
  before_filter :restrict_access, :except => [:index, :show]
  before_filter :restrict_invoice_access, :except => [:index]
  before_filter :restrict_account_access, :except => [:index, :new, :create]

  def index
    if signed_in_client.is_account_master
      @invoices = @account.invoices.find(:all, :include => :client)
    else
      @invoices = signed_in_client.invoices.find(:all, :include => :client)
    end

    respond_to do |format|
      format.html
      format.json { render json: @invoices }
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
    @client = Client.find_by_id(@invoice.client_id)

    respond_to do |format|
      format.html
      format.json { render json: @invoice }
    end
  end

  def new
    @invoice = Invoice.new(number: @account.invoices.default_number)
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(params[:client_id])
    @invoice.client_id = @client.id if @client
    3.times do
      line_item = @invoice.line_items.build
    end

    respond_to do |format|
      format.html
      format.json { render json: @invoice }
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(@invoice.client_id)
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoice_path(@invoice), :flash => {:notice => 'Invoice was successfully created.', :status => 'success'} }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to invoice_path(@invoice), :flash => {:notice => 'Invoice was successfully updated.', :status => 'success'} }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :ok }
    end
  end

  def generateInvoiceFromMilestone
    @invoice = Invoice.new(number: @account.invoices.default_number)
    @invoice.date = Date.today
    @invoice_milestone = InvoiceMilestone.find_by_id(params[:invoice_milestone_id])
    @invoice_schedule = InvoiceSchedule.find_by_id(@invoice_milestone.invoice_schedule_id)
    @estimate = Estimate.find_by_id(@invoice_schedule.estimate_id)
    @client = Client.find_by_id(@estimate.client_id)
    @line_items = @estimate.line_items.where(:is_enabled => true)
    @invoice.client_id = @client.id
    @invoice.save
    @invoice_milestone.invoice_id = @invoice.id
    @invoice_milestone.save
    percent = Float(@invoice_milestone.estimate_percentage)/100
    @line_items.each do |line_item|
      new_line_item = line_item.dup
      new_line_item.unit_price = Float(line_item.unit_price) * percent
      new_line_item.invoice_id = @invoice.id
      new_line_item.estimate_id = nil
      new_line_item.save
    end

    respond_to do |format|
      format.html { redirect_to invoice_path(@invoice), :flash => {:notice => 'Invoice was successfully generated.', :status => 'success'} }
      format.json { head :ok }
    end
  end

  private

      def restrict_invoice_access
      unless signed_in_client.is_account_master
        @invoice = Invoice.find(params[:id])
        unless signed_in_client.id == @invoice.client_id
          redirect_to invoices_path
        end
      end

      def restrict_account_access
        if params[:invoice_milestone_id]
          @estimate = InvoiceMilestone.find(params[:invoice_milestone_id]).invoice_schedule.estimate
          @estimate_account = @estimate.client.account
          if @estimate_account != @account
            redirect_to site_url
          end
        else
          @invoice = Invoice.find(params[:id])
          @invoice_client = Client.find_by_id(@invoice.client_id)
          @invoice_account = Account.find_by_id(@invoice_client.account_id)
          if @invoice_account != @account
            redirect_to site_url
          end
        end
      end
    end

end
