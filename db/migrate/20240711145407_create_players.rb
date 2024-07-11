class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :riot_id
      t.string :game_tag
      t.string :puuid
      t.integer :squad_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.float :win_rate
      t.float :kills
      t.float :deaths
      t.float :assists

      t.index :squad_id, name: "index_players_on_squad_id"
    end

    add_foreign_key :players, :squads
  end
end
