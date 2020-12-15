class LicenseKey < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :key, presence: true, uniqueness: true

  before_validation do
    if key.blank?
      self.key = self.class.generate_key
    end
  end

  class << self
    def generate_key
      begin
        key = 'lk_' + SecureRandom.hex
      end while exists?(key: key)
      key
    end
  end
end
