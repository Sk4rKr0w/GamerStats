class AddStatusToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :status, :string
  end
end
