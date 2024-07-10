class Ticket < ApplicationRecord
  belongs_to :user
  validates :subject, presence: true
  validates :message, presence: true
  validates :status, inclusion: { in: %w(open resolved), message: "%{value} is not a valid status" }
end
