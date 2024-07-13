class DropTicketsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :tickets
  end

  def down
    create_table :tickets do |t|
      t.integer :user_id
      t.string :subject
      t.text :message
      t.string :status, default: "open"
      t.timestamps
    end

    add_index :tickets, :user_id
  end
end
