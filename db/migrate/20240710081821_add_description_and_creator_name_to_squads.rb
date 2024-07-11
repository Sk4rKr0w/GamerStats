class AddDescriptionAndCreatorNameToSquads < ActiveRecord::Migration[7.1]
  def change
    add_column :squads, :description, :string
    add_column :squads, :creator_name, :string
  end
end
