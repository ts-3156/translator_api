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

  class << self
    def find_by(key:)
      record, type =
        if key.match?(/\Alk_trial_/)
          [TrialLicense.first, 'trial']
        elsif key.match?(/\Alk_free_/)
          [FreeLicense.find_by(key: key), 'free']
        elsif key.match?(/\Alk_pro_/)
          [ProLicense.find_by(key: key), 'pro']
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
