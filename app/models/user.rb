class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)

  has_one :credential
  has_many :subscriptions
  has_many :licenses

  validates :uid, presence: true, uniqueness: true
  validates :email, presence: true

  def has_subscription?
    subscriptions.not_canceled.charge_not_failed.any?
  end

  def active_subscription
    subscriptions.not_canceled.charge_not_failed.order(created_at: :desc).first
  end

  def has_license?
    licenses.not_revoked.any?
  end

  def active_license
    licenses.not_revoked.order(created_at: :desc).first
  end

  class << self
    def from_omniauth(auth)
      user = find_or_initialize_by(uid: auth.uid)
      user.email = auth.info.email

      if user.new_record?
        transaction do
          user.save!
          user.create_credential!(access_token: auth.credentials.token, refresh_token: auth.credentials.refresh_token)
          user.licenses.create!(key_type: 'free')
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
