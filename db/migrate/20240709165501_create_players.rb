class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :riot_id
      t.string :game_tag
      t.string :puuid
      t.references :squad, null: false, foreign_key: true

      t.timestamps
    end
  end
end
