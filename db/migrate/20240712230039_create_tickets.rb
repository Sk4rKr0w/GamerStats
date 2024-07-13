class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.integer :user_id, null: false
      t.string :subject
      t.text :message
      t.string :status, default: "open"
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :tickets, :user_id, name: "index_tickets_on_user_id"
    add_foreign_key :tickets, :users
  end
end
