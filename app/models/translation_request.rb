class TranslationRequest < ApplicationRecord

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

  class << self
    def from_params(params)
      license = License.find_by(key: params[:license_key])
      new(license_type: license.type, license_id: license.id, text: params[:text], source_lang: params[:source_lang], target_lang: params[:target_lang])
    end
  end

  def perform_translate
    Deepl.new(text, source_lang == 'automatic' ? nil : source_lang, target_lang).translate
  end
end
