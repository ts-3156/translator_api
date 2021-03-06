# == Schema Information
#
# Table name: translation_requests
#
#  id           :bigint           not null, primary key
#  license_type :string(255)      not null
#  license_id   :bigint           not null
#  source_lang  :string(255)
#  target_lang  :string(255)
#  text         :text(65535)
#  created_at   :datetime         not null
#
# Indexes
#
#  index_translation_requests_on_created_at  (created_at)
#
class TranslationRequest < ApplicationRecord

  attr_accessor :license

  validates :license_type, presence: true
  validates :license_id, presence: true
  validates :text, presence: true
  validates :source_lang, inclusion: { in: ['automatic', 'de', 'en', 'en-gb', 'en-us', 'fr', 'es', 'it', 'ja', 'nl', 'pl', 'pt', 'pt-br', 'pt-pt', 'ru', 'zh'] }
  validates :target_lang, inclusion: { in: ['de', 'en', 'en-gb', 'en-us', 'fr', 'es', 'it', 'ja', 'nl', 'pl', 'pt', 'pt-br', 'pt-pt', 'ru', 'zh'] }

  before_validation :downcase_fields

  def downcase_fields
    if source_lang.present?
      source_lang.downcase!
    end

    if target_lang.present?
      target_lang.downcase!
    end
  end

  validate :limit_chars_per_translation
  validate :limit_total_chars

  def limit_chars_per_translation
    if license && license.chars_per_translation_exceeded?(text)
      errors.add(:base, 'limit_chars_per_translation')
    end
  end

  def limit_total_chars
    if license && license.total_chars_will_exceed?(text)
      errors.add(:base, 'limit_total_chars')
    end
  end

  class << self
    def from_params(params)
      license = License.find_by(key: params[:license_key])
      new(license: license, license_type: license&.type, license_id: license&.id, text: params[:text], source_lang: params[:source_lang], target_lang: params[:target_lang])
    end
  end

  def perform_translate
    Deepl.new(text, source_lang == 'automatic' ? nil : source_lang, target_lang).translate
  end
end
