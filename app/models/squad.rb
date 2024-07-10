class Squad < ApplicationRecord
  belongs_to :user
  has_many :players, dependent: :destroy
  accepts_nested_attributes_for :players

  validates :name, presence: true
  validates :description, presence: true
  validates :creator_name, presence: true

  def average_win_rate
    return 0 if players.empty?

    total_win_rate = players.sum(&:win_rate)
    total_win_rate / players.size
  end

  def average_kda
    return "0/0/0" if players.empty?

    total_kills = players.sum { |player| player.kills.to_f }
    total_deaths = players.sum { |player| player.deaths.to_f }
    total_assists = players.sum { |player| player.assists.to_f }

    avg_kills = total_kills / players.size
    avg_deaths = total_deaths / players.size
    avg_assists = total_assists / players.size

    "#{avg_kills.round(2)}/#{avg_deaths.round(2)}/#{avg_assists.round(2)}"
  end
end
