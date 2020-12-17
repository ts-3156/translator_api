class FreeLicense < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :key, presence: true, uniqueness: true

  before_validation do
    if key.blank?
      self.key = self.class.generate_key
    end
  end

  scope :not_revoked, -> { where(revoked_at: nil) }

  def revoke!
    update!(revoked_at: Time.zone.now)
  end

  class << self
    def generate_key
      begin
        key = "lk_free_#{SecureRandom.hex}"
      end while exists?(key: key)
      key
    end
  end
end
