class InvoicesController < ApplicationController
  # GET /invoices
  # GET /invoices.json
  before_filter :get_account
  before_filter :inner_navigation
  before_filter :restrict_access
  def index
    #@invoices = Invoice.all
    if signed_in_client.is_account_master
      @invoices = @account.invoices.find(:all, :include => :client)
    else
      @estimates = signed_in_client.invoices.find(:all, :include => :client)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])
    @client = Client.find_by_id(@invoice.client_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new(number: @account.invoices.default_number)
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
    @clients = @account.clients.find(:all, :conditions => {:is_account_master => false})
    @client = Client.find_by_id(@invoice.client_id)
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to account_invoice_path(@account,@invoice), notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to account_invoice_path(@account,@invoice), notice: 'Invoice was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to account_invoices_url }
      format.json { head :ok }
    end
  end
end
