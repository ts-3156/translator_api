# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  uid        :string(255)      not null
#  email      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_created_at  (created_at)
#  index_users_on_uid         (uid) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)

  has_one :credential
  has_many :subscriptions
  has_many :free_licenses
  has_many :pro_licenses

  validates :uid, presence: true, uniqueness: true
  validates :email, presence: true

  def has_subscription?
    subscriptions.not_canceled.charge_not_failed.any?
  end

  def current_subscription
    subscriptions.not_canceled.charge_not_failed.order(created_at: :desc).first
  end

  def has_free_license?
    free_licenses.not_revoked.any?
  end

  def has_pro_license?
    pro_licenses.not_revoked.any?
  end

  def current_free_license
    free_licenses.not_revoked.order(created_at: :desc).first
  end

  def current_pro_license
    pro_licenses.not_revoked.order(created_at: :desc).first
  end

  def current_license
    if has_pro_license?
      current_pro_license
    elsif has_free_license?
      current_free_license
    end
  end

  class << self
    def from_omniauth(auth)
      user = find_or_initialize_by(uid: auth.uid)
      user.email = auth.info.email

      if user.new_record?
        transaction do
          user.save!
          user.create_credential!(access_token: auth.credentials.token, refresh_token: auth.credentials.refresh_token)
          user.free_licenses.create!
        end
      else
        user.save! if user.changed?

        user.credential.assign_attributes(access_token: auth.credentials.token) if auth.credentials.token.any?
        user.credential.assign_attributes(refresh_token: auth.credentials.refresh_token) if auth.credentials.refresh_token.any?
        user.credential.save! if user.credential.changed?
      end

      user
    rescue => e
      logger.warn "from_omniauth: cannot save user and credential exception=#{e.inspect} auth=#{auth.inspect}"
      raise
    end
  end
end
