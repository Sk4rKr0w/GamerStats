class DropTicketsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :tickets
  end

  def down
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.text :message
      t.string :status
      t.timestamps
    end
  end
end
