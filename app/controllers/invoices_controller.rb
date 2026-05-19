class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy]
  allow_unauthenticated_access only: %i[ show index ]

  def index
    @invoices = Invoice.all
  end

  def show
    respond_to do |format|
      format.html

      format.pdf do
        pdf = Prawn::Document.new

        pdf.text "Invoice #{@invoice.invoice_number}", size: 24, style: :bold
        pdf.move_down 20

        pdf.text "Client: #{@invoice.client.name}"
        pdf.text "Issue date: #{@invoice.issue_date}"
        pdf.text "Due date: #{@invoice.due_date}"
        pdf.text "Status: #{@invoice.status}"

        pdf.move_down 20
        pdf.text "Line items", size: 16, style: :bold

        @invoice.line_items.each do |item|
          pdf.text "#{item.description} - #{item.quantity} x #{item.unit_price_cents} cents = #{item.total_cents} cents"
        end

        pdf.move_down 20
        pdf.text "Subtotal: #{@invoice.subtotal_cents} cents", style: :bold

        send_data pdf.render,
          filename: "invoice-#{@invoice.invoice_number}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  def new
    @invoice = Invoice.new

    @invoice.line_items.build
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to @invoice
    else
      @invoice.line_items.build if @invoice.line_items.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice.line_items.build if @invoice.line_items.empty?
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
      params.expect(invoice: [ :client_id, :issue_date, :due_date, :status, :notes,
      { line_items_attributes: [ [
        :id,
        :description,
        :quantity,
        :unit_price_cents,
        :_destroy
      ] ] } ])
    end
end
