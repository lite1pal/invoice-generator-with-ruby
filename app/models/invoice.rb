class Invoice < ApplicationRecord
  belongs_to :client

  enum :status, {
    draft: 0,
    sent: 1,
    paid: 2,
    overdue: 3
  }

  validates :invoice_number, presence: true, uniqueness: true
  validates :issue_date, :due_date, presence: true
end
