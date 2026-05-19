class LineItem < ApplicationRecord
  belongs_to :invoice

  attr_accessor :unit_price

  before_validation :convert_unit_price_to_cents

  validates :description, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_cents, numericality: { only_integer: true, greater_than: 0 }

  def total_cents
    quantity * unit_price_cents
  end

  def unit_price
    return @unit_price if defined?(@unit_price) && @unit_price.present?
    return nil if unit_price_cents.nil?
    format("%.2f", unit_price_cents / 100.0)
  end

  private

  def convert_unit_price_to_cents
    return if @unit_price.blank?

    value = BigDecimal(@unit_price.to_s)
    self.unit_price_cents = (value * 100).round(0).to_i
  end

rescue ArgumentError
  self.unit_price_cents = nil
end
