class AddDescriptionAndCreatorNameToSquads < ActiveRecord::Migration[7.1]
  def create
    add_column :squads, :description, :string
    add_column :squads, :creator_name, :string
  end
end
