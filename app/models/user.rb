class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]


  
   def generate_two_factor_code
      self.two_factor_code = rand(100000..999999).to_s
      self.two_factor_expires_at = 10.minutes.from_now
      update_columns(two_factor_code: two_factor_code, two_factor_expires_at: two_factor_expires_at)
    end
      
    def send_two_factor_code
      generate_two_factor_code
      UserMailer.two_factor_code(self).deliver_now
    end
      
    def verify_two_factor_code(code)
      return false if two_factor_expires_at < Time.current
      self.two_factor_code == code
    end

    def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first
  
      unless user
        user = User.create(
          name: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0, 20]
        )
      end
      user
    end


  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :riot_id, uniqueness: true, allow_blank: true
  validates :battle_id, uniqueness: true, allow_blank: true
end
