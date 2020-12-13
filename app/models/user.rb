class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)

  has_one :credential

  validates :uid, presence: true, uniqueness: true
  validates :email, presence: true

  class << self
    def from_omniauth(auth)
      user = find_or_initialize_by(uid: auth.uid)
      user.email = auth.info.email

      if user.new_record?
        transaction do
          user.save!
          user.create_credential!(access_token: auth.credentials.token, refresh_token: auth.credentials.refresh_token)
        end
      else
        user.save! if user.changed?

        user.credential.assign_attributes(access_token: auth.credentials.token, refresh_token: auth.credentials.refresh_token)
        user.credential.save! if user.credential.changed?
      end

      user
    end
  end
end
