class CreatePatchNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :patch_notes do |t|
      t.string :title
      t.text :description
      t.string :game
      t.string :image_path

      t.timestamps
    end
  end
end
