# == Schema Information
#
# Table name: trial_licenses
#
#  id         :bigint           not null, primary key
#  key        :string(255)      not null
#  revoked_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_trial_licenses_on_created_at  (created_at)
#  index_trial_licenses_on_key         (key) UNIQUE
#
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
