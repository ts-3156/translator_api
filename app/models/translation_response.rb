class TranslationResponse < ApplicationRecord
  belongs_to :translation_request

  validates :translation_request_id, presence: true
  validates :text, presence: true
  validates :detected_source_language, inclusion: { in: ['de', 'en', 'en-gb', 'en-us', 'fr', 'es', 'it', 'ja', 'nl', 'pl', 'pt', 'pt-br', 'pt-pt', 'ru', 'zh'] }

  before_validation :downcase_fields

  def downcase_fields
    if detected_source_language.present?
      detected_source_language.downcase!
    end
  end

  class << self
    def from_api_response(translation_request_id, api_response)
      translation = JSON.parse(api_response)['translations'][0]
      new(translation_request_id: translation_request_id, text: translation['text'], detected_source_language: translation['detected_source_language'])
    end
  end
end
