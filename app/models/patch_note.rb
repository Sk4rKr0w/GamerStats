# app/models/patch_note.rb
class PatchNote < ApplicationRecord
  validates :title, :description, :image_path, presence: true
end
