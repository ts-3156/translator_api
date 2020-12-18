require 'active_support/concern'

module LicenseToken
  extend ActiveSupport::Concern

  class_methods do
    def generate_key(license_type)
      begin
        key = "lk_#{license_type}_#{SecureRandom.hex}"
      end while exists?(key: key)
      key
    end
  end
end
