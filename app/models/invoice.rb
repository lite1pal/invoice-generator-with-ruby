class Invoice < ApplicationRecord
  belongs_to :client
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true

  before_validation :calculate_amounts
  before_validation :assign_invoice_number, on: :create

  enum :status, {
    draft: 0,
    sent: 1,
    paid: 2,
    overdue: 3
  }

  validates :issue_date, :due_date, presence: true

  private

  TAX_RATE = 0.0

  def calculate_amounts
    self.subtotal_cents = line_items.reject(&:marked_for_destruction?).sum do |item|
      item.quantity.to_i * item.unit_price_cents.to_i
    end

    self.tax_cents = (subtotal_cents * TAX_RATE).round
    self.total_cents = subtotal_cents + tax_cents
  end

  def assign_invoice_number
    return if invoice_number.present?

    self.invoice_number = self.class.next_invoice_number
  end

  def self.next_invoice_number
    last_number = order(created_at: :desc).limit(1).pick(:invoice_number)
    last_seq = last_number&.match(/(\d+)\z/)&.captures&.first.to_i
    format("INV-%04d", last_seq + 1)
  end
end
