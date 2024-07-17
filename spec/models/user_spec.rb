require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      FactoryBot.create(:user, email: 'test@example.com')
      user = FactoryBot.build(:user, email: 'test@example.com')
      expect(user).to_not be_valid
    end

    it 'is not valid with a short password' do
      user = FactoryBot.build(:user, password: 'short')
      expect(user).to_not be_valid
    end

    it 'is not valid with a password without complexity' do
      user = FactoryBot.build(:user, password: 'password')
      expect(user).to_not be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:squads).dependent(:destroy) }

    it 'destroys dependent squads' do
      user = FactoryBot.create(:user)
      squad = FactoryBot.create(:squad, user: user)
      expect { user.destroy }.to change { Squad.count }.by(-1)
    end
  end

  describe 'methods' do
    let(:user) { FactoryBot.create(:user) }

    describe '#generate_two_factor_code' do
      it 'generates a six-digit code' do
        user.generate_two_factor_code
        expect(user.two_factor_code).to match(/\A\d{6}\z/)
      end

      it 'sets the expiration time for the code' do
        user.generate_two_factor_code
        expect(user.two_factor_expires_at).to be_within(1.minute).of(10.minutes.from_now)
      end
    end

    describe '#verify_two_factor_code' do
      it 'returns true for a valid code within the expiration time' do
        user.generate_two_factor_code
        expect(user.verify_two_factor_code(user.two_factor_code)).to be true
      end

      it 'returns false for an invalid code' do
        user.generate_two_factor_code
        expect(user.verify_two_factor_code('wrong_code')).to be false
      end

      it 'returns false for an expired code' do
        user.generate_two_factor_code
        user.update(two_factor_expires_at: 1.minute.ago)
        expect(user.verify_two_factor_code(user.two_factor_code)).to be false
      end
    end

    describe '#banned?' do
      it 'returns true if the user is banned' do
        user.update(banned_until: 1.day.from_now)
        expect(user.banned?).to be true
      end

      it 'returns false if the user is not banned' do
        expect(user.banned?).to be false
      end

      it 'returns false if the ban has expired' do
        user.update(banned_until: 1.day.ago)
        expect(user.banned?).to be false
      end
    end

    describe '#admin?' do
      it 'returns true if the user is an admin' do
        admin_user = FactoryBot.create(:user, :admin)
        expect(admin_user.admin?).to be true
      end

      it 'returns false if the user is not an admin' do
        expect(user.admin?).to be false
      end
    end
  end

  describe 'omniauth' do
    it 'creates a user from omniauth data' do
      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'newuser@example.com'
        }
      )
      user = User.from_omniauth(auth)
      expect(user).to be_persisted
      expect(user.email).to eq('newuser@example.com')
    end

    it 'does not create a new user if the email already exists' do
      existing_user = FactoryBot.create(:user, email: 'existing@example.com')
      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'existing@example.com'
        }
      )
      user = User.from_omniauth(auth)
      expect(user).to eq(existing_user)
    end
  end
end
