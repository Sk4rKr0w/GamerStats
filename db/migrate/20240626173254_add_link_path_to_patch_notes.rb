class AddLinkPathToPatchNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :patch_notes, :link_path, :string
  end
end
