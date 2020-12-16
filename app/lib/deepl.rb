require 'net/http'

class Deepl
  def initialize(text, source_lang, target_lang)
    @text = text
    @source_lang = source_lang
    @target_lang = target_lang
  end

  def translate
    params = {
      auth_key: ENV['TRANSLATION_AUTH_KEY'],
      text: @text,
      source_lang: @source_lang,
      target_lang: @target_lang,
      tag_handling: 0,
    }
    post(params)
  end

  private

  def post(params)
    # TODO Set timeout
    uri = URI.parse('https://api.deepl.com/v2/translate')
    Net::HTTP.post_form(uri, params).body
  end
end
