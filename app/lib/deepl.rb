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
    uri = URI.parse('https://api.deepl.com/v2/translate')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.open_timeout = 3
    https.read_timeout = 3
    https.write_timeout = 3
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/x-www-form-urlencoded'
    req.set_form_data(params)
    https.start { https.request(req) }.body
  end
end
