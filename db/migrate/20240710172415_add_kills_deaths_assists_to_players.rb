class AddKillsDeathsAssistsToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :kills, :float
    add_column :players, :deaths, :float
    add_column :players, :assists, :float
  end
end
