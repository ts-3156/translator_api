class TrialLicense < ApplicationRecord
  include LicenseToken
  include LicenseRevocable
  include LicenseLimitation

  validates :key, presence: true, uniqueness: true

  before_validation do
    if key.blank?
      self.key = self.class.generate_key(license_type)
    end
  end

  def license_type
    :trial
  end
end
