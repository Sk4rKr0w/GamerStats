class CreateSquads < ActiveRecord::Migration[7.1]
  def change
    create_table :squads do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
