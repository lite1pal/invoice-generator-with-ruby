class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy]
  allow_unauthenticated_access only: %i[ show index ]

  def index
    @invoices = Invoice.all
  end

  def show
  end

  def new
    @invoice = Invoice.new

    3.times do
      @invoice.line_items.build
    end
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to @invoice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "Invoice was updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.expect(invoice: [ :client_id, :invoice_number, :issue_date, :due_date, :status, :notes, line_items_attributes: [
        :id,
        :description,
        :quantity,
        :unit_price_cents,
        :_destroy
      ] ])
    end
end
