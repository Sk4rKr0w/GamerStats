class Squad < ApplicationRecord
  belongs_to :user
  has_many :players, dependent: :destroy
  accepts_nested_attributes_for :players

  def average_win_rate
    return 0 if players.empty?

    total_win_rate = players.sum(&:win_rate)
    total_win_rate / players.size
  end
end
