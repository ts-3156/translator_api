# == Schema Information
#
# Table name: pro_licenses
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  subscription_id :bigint           not null
#  key             :string(255)      not null
#  revoked_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pro_licenses_on_created_at       (created_at)
#  index_pro_licenses_on_key              (key) UNIQUE
#  index_pro_licenses_on_subscription_id  (subscription_id)
#  index_pro_licenses_on_user_id          (user_id)
#
class ProLicense < ApplicationRecord
  include LicenseToken
  include LicenseRevocable
  include LicenseLimitation

  belongs_to :user

  validates :user_id, presence: true
  validates :subscription_id, presence: true
  validates :key, presence: true, uniqueness: true

  before_validation do
    if key.blank?
      self.key = self.class.generate_key(license_type)
    end
  end

  def license_type
    :pro
  end
end
