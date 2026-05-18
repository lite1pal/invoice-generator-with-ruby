class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :company
      t.string :email
      t.string :phone
      t.string :address
      t.string :tax_id

      t.timestamps
    end
  end
end
