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
