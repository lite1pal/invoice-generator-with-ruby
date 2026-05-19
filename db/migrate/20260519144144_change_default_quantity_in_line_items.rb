class ChangeDefaultQuantityInLineItems < ActiveRecord::Migration[8.1]
  def change
    change_column_default :line_items, :quantity, 1
  end
end
