class Invoice < ApplicationRecord
  belongs_to :client
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true

  enum :status, {
    draft: 0,
    sent: 1,
    paid: 2,
    overdue: 3
  }

  validates :invoice_number, presence: true, uniqueness: true
  validates :issue_date, :due_date, presence: true

  def subtotal_cents
      line_items.sum(&:total_cents)
  end
end
