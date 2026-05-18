class AddDescriptionToClients < ActiveRecord::Migration[8.1]
  def change
    add_column :clients, :description, :string
  end
end
