require 'rails_helper'

RSpec.describe Squad, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:players).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:creator_name) }
  end

  describe 'average_win_rate' do
    context 'when there are no players' do
      let(:squad) { FactoryBot.create(:squad) }

      it 'returns 0' do
        expect(squad.average_win_rate).to eq(0)
      end
    end

    context 'when there are players' do
      let(:squad) { FactoryBot.create(:squad, :with_players, players_count: 3) }

      it 'returns the average win rate of the players' do
        total_win_rate = squad.players.sum(&:win_rate)
        expected_average = total_win_rate / squad.players.size

        expect(squad.average_win_rate).to eq(expected_average)
      end
    end
  end

  describe 'average_kda' do
    context 'when there are no players' do
      let(:squad) { FactoryBot.create(:squad) }

      it 'returns "0/0/0"' do
        expect(squad.average_kda).to eq("0/0/0")
      end
    end

    context 'when there are players' do
      let(:squad) { FactoryBot.create(:squad, :with_players, players_count: 3) }

      it 'returns the average KDA of the players' do
        total_kills = squad.players.sum(&:kills)
        total_deaths = squad.players.sum(&:deaths)
        total_assists = squad.players.sum(&:assists)

        avg_kills = total_kills / squad.players.size
        avg_deaths = total_deaths / squad.players.size
        avg_assists = total_assists / squad.players.size

        expected_kda = "#{avg_kills.round(2)}/#{avg_deaths.round(2)}/#{avg_assists.round(2)}"

        expect(squad.average_kda).to eq(expected_kda)
      end
    end
  end
end
