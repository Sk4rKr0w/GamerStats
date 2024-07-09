class AddSavedToSquads < ActiveRecord::Migration[7.1]
  def change
    add_column :squads, :saved, :boolean, default: false, null: false
  end
end
