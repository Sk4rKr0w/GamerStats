class DropUnusedTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :champions
    drop_table :contacts
    drop_table :patch_notes
    drop_table :users
    drop_table :players
    drop_table :squads
    drop_table :tickets
  end
end
