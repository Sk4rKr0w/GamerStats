class CreateSquads < ActiveRecord::Migration[7.1]
  def change
    create_table :squads do |t|
      t.string :name
      t.integer :user_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.boolean :saved, default: false, null: false
      t.string :description
      t.string :creator_name

      t.index :user_id, name: "index_squads_on_user_id"
    end

    add_foreign_key :squads, :users
  end
end
