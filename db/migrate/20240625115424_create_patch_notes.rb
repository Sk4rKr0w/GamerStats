class CreatePatchNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :patch_notes do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :game, null: false
      t.string :image_path, null: false
      t.text :link_path, null: false

      t.timestamps
    end
  end
end
