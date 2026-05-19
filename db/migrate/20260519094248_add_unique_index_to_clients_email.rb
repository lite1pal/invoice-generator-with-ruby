class AddUniqueIndexToClientsEmail < ActiveRecord::Migration[8.1]
  def change
    add_index :clients, :email, unique: true
  end
end
