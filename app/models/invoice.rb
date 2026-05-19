class Invoice < ApplicationRecord
  belongs_to :client
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true

  before_validation :calculate_amounts

  enum :status, {
    draft: 0,
    sent: 1,
    paid: 2,
    overdue: 3
  }

  validates :invoice_number, presence: true, uniqueness: true
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
end
