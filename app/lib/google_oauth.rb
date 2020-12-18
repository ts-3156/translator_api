require 'net/http'

class GoogleOauth
  def initialize(access_token: nil, refresh_token: nil)
    @access_token = access_token
    @refresh_token = refresh_token
  end

  def uid
    res = get('https://www.googleapis.com/oauth2/v1/userinfo?access_token=' + @access_token, @access_token)
    JSON.parse(res)['id']
  end

  def access_token
    params = {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      refresh_token: @refresh_token,
      grant_type: 'refresh_token'
    }
    res = post('https://www.googleapis.com/oauth2/v4/token', params)
    JSON.parse(res)['access_token']
  end

  private

  def get(url, access_token)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.open_timeout = 3
    https.read_timeout = 3
    https.write_timeout = 3
    req = Net::HTTP::Get.new(uri)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = 'Bearer ' + access_token
    https.start { https.request(req) }.body
  end

  def post(url, params)
    uri = URI.parse(url)
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
