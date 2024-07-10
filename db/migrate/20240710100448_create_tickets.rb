class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.text :message
      t.string :status, default: 'open'

      t.timestamps
    end
  end
end
