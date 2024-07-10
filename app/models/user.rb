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
    user = where(email: auth.info.email).first_or_initialize do |new_user|
      new_user.provider = auth.provider
      new_user.uid = auth.uid
      new_user.email = auth.info.email
      new_user.password = Devise.friendly_token[0, 20]
      # Se desideri aggiungere altre informazioni dall'auth hash, puoi farlo qui
    end
    user.save(validate: false) if user.new_record?
    user
  end

  def banned?
    banned_until.present? && banned_until > Time.current
  end

  def admin?
    self.admin
  end

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, allow_blank: true
  validates :riot_id, uniqueness: true, allow_blank: true
  validates :battle_id, uniqueness: true, allow_blank: true

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/

    errors.add :password, 'Complexity requirement not met. Length should be 8-128 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end
