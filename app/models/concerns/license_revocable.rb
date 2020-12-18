require 'active_support/concern'

module LicenseRevocable
  extend ActiveSupport::Concern

  included do
    scope :not_revoked, -> { where(revoked_at: nil) }
  end

  def revoke!
    update!(revoked_at: Time.zone.now)
  end
end
