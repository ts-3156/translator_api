class License < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :key, presence: true, uniqueness: true

  attr_accessor :key_type

  before_validation do
    if key.blank?
      self.key = self.class.generate_key(key_type)
    end
  end

  scope :not_revoked, -> { where(revoked_at: nil) }

  def revoke!
    update!(revoked_at: Time.zone.now)
  end

  def pro?
    metadata && metadata['subscription_id']
  end

  class << self
    def find_by_metadata(subscription_id:)
      where('metadata->>"$.subscription_id" = ?', subscription_id).first
    end

    def trial_license
      find(1)
    end

    def generate_key(key_type)
      key_type = %w(free pro).include?(key_type) ? key_type : 'free'
      begin
        key = "lk_#{key_type}_#{SecureRandom.hex}"
      end while exists?(key: key)
      key
    end
  end
end
