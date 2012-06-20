class InvoiceSchedulesController < ApplicationController
  # GET /invoice_schedules
  # GET /invoice_schedules.json
  def index
    @invoice_schedules = InvoiceSchedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice_schedules }
    end
  end

  # GET /invoice_schedules/1
  # GET /invoice_schedules/1.json
  def show
    @invoice_schedule = InvoiceSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice_schedule }
    end
  end

  # GET /invoice_schedules/new
  # GET /invoice_schedules/new.json
  def new
    @invoice_schedule = InvoiceSchedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice_schedule }
    end
  end

  # GET /invoice_schedules/1/edit
  def edit
    @invoice_schedule = InvoiceSchedule.find(params[:id])
  end

  # POST /invoice_schedules
  # POST /invoice_schedules.json
  def create
    @invoice_schedule = InvoiceSchedule.new(params[:invoice_schedule])

    respond_to do |format|
      if @invoice_schedule.save
        format.html { redirect_to @invoice_schedule, notice: 'Invoice schedule was successfully created.' }
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

    respond_to do |format|
      if @invoice_schedule.update_attributes(params[:invoice_schedule])
        format.html { redirect_to @invoice_schedule, notice: 'Invoice schedule was successfully updated.' }
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
    @invoice_schedule.destroy

    respond_to do |format|
      format.html { redirect_to invoice_schedules_url }
      format.json { head :ok }
    end
  end
end
