class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :client, null: false, foreign_key: true
      t.string :invoice_number, null: false
      t.date :issue_date, null: false
      t.date :due_date, null: false
      t.integer :status, null: false, default: 0
      t.text :notes
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :tax_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0

      t.timestamps
    end

    add_index :invoices, :invoice_number, unique: true
  end
end
