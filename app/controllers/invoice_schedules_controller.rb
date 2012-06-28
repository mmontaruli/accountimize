class InvoiceSchedulesController < ApplicationController
  # GET /invoice_schedules
  # GET /invoice_schedules.json

  before_filter :get_account
  before_filter :inner_navigation
  before_filter :restrict_access
  before_filter :restrict_account_access, :except => [:index, :new, :create]
  def index
    @invoice_schedules = InvoiceSchedule.all
    @estimate = Estimate.find_by_id(params[:estimate_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice_schedules }
    end
  end

  # GET /invoice_schedules/1
  # GET /invoice_schedules/1.json
  def show
    @invoice_schedule = InvoiceSchedule.find(params[:id])
    @estimate = Estimate.find_by_id(@invoice_schedule.estimate_id)
    @estimate_number = @estimate.number

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice_schedule }
    end
  end

  # GET /invoice_schedules/new
  # GET /invoice_schedules/new.json
  def new
    @invoice_schedule = InvoiceSchedule.new
    @estimate = Estimate.find_by_id(params[:estimate_id])
    #3.times do
    #  invoice_milestone = @invoice_schedule.invoice_milestones.build
    #end
    invoice_milestone = @invoice_schedule.invoice_milestones.build(:estimate_percentage => 100)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice_schedule }
    end
  end

  # GET /invoice_schedules/1/edit
  def edit
    @invoice_schedule = InvoiceSchedule.find(params[:id])
    @estimate = nil
    @estimate_number = Estimate.find_by_id(@invoice_schedule.estimate_id).number
  end

  # POST /invoice_schedules
  # POST /invoice_schedules.json
  def create
    @invoice_schedule = InvoiceSchedule.new(params[:invoice_schedule])
    @estimate = Estimate.find_by_id(params[:estimate_id])

    respond_to do |format|
      if @invoice_schedule.save
        format.html { redirect_to invoice_schedule_path(@invoice_schedule), :flash => {:notice => 'Invoice schedule was successfully created.', :status => 'success'} }
        format.json { render json: @invoice_schedule, status: :created, location: @invoice_schedule }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoice_schedules/1
  # PUT /invoice_schedules/1.json
  def update
    @invoice_schedule = InvoiceSchedule.find(params[:id])
    #@estimate = Estimate.find_by_id(@invoice_schedule.estimate_id)

    respond_to do |format|
      if @invoice_schedule.update_attributes(params[:invoice_schedule])
        format.html { redirect_to invoice_schedule_path(@invoice_schedule), :flash => {:notice => 'Invoice schedule was successfully updated.', :status => 'success'} }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoice_schedules/1
  # DELETE /invoice_schedules/1.json
  def destroy
    @invoice_schedule = InvoiceSchedule.find(params[:id])
    @estimate = Estimate.find_by_id(@invoice_schedule.estimate_id)
    @invoice_schedule.destroy
    #@estimate = Estimate.find_by_id(params[:estimate_id])

    respond_to do |format|
      format.html { redirect_to estimate_path(@estimate) }
      format.json { head :ok }
    end
  end

  private

  def restrict_account_access
    @invoice_schedule = InvoiceSchedule.find(params[:id])
    @invoice_schedule_estimate = Estimate.find_by_id(@invoice_schedule.estimate_id)
    @invoice_schedule_client = Client.find_by_id(@invoice_schedule_estimate.client_id)
    @invoice_schedule_account = Account.find_by_id(@invoice_schedule_client.account_id)
    if @invoice_schedule_account != @account
      redirect_to site_url
    end
  end
end
