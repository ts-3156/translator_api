class License

  def initialize(record, type)
    @record = record
    @type = type
  end

  def id
    @record.id
  end

  def key
    @record.key
  end

  def type
    @type
  end

  def translated_chars(days)
    @record.translated_chars(days)
  end

  def limited_chars(days)
    @record.limited_chars(days)
  end

  def chars_per_translation_exceeded?(text)
    @record.chars_per_translation_exceeded?(text)
  end

  def total_chars_will_exceed?(text)
    @record.total_chars_will_exceed?(text)
  end

  class << self
    def find_by(key:)
      record, type =
        if key.match?(/\Alk_trial_\w{30,50}\z/)
          [TrialLicense.not_revoked.find_by(key: key), 'trial']
        elsif key.match?(/\Alk_free_\w{30,50}\z/)
          [FreeLicense.not_revoked.find_by(key: key), 'free']
        elsif key.match?(/\Alk_pro_\w{30,50}\z/)
          [ProLicense.not_revoked.find_by(key: key), 'pro']
        else
          nil
        end

      if record
        new(record, type)
      else
        nil
      end
    end

  end
end
