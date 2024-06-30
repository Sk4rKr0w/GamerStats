class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  validate :password_complexity

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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.nickname = auth.info.name  # Aggiungi il nickname se disponibile
    end
  end

  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :riot_id, uniqueness: true, allow_blank: true
  validates :battle_id, uniqueness: true, allow_blank: true

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/

    errors.add :password, 'Complexity requirement not met. Length should be 8-128 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end
