require 'active_support/concern'

module LicenseLimitation
  extend ActiveSupport::Concern

  class_methods do
  end

  # TODO Fix performance issue
  def translation_requests(days)
    TranslationRequest.where('created_at > ?', days.days.ago).where(license_type: license_type, license_id: id)
  end

  def translated_chars(days)
    translation_requests(days).map(&:text).map(&:size).sum
  end

  def limited_chars(days)
    if days == 30
      Limitation::TOTAL_CHARS[license_type]
    else
      raise "days is invalid value=#{days}"
    end
  end

  def chars_per_translation_exceeded?(text)
    Limitation::CHARS_PER_TRANSLATION[license_type] < text.length
  end

  def total_chars_will_exceed?(text)
    chars_count = translation_requests(30).map(&:text).map(&:size).sum
    Limitation::TOTAL_CHARS[license_type] < chars_count + text.length
  end
end
