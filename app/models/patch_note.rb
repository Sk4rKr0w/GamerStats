class PatchNote < ApplicationRecord
  validates :title, :description, :image_path, :game, :link_path, presence: true
end
