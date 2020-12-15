module PathsHelper
  def store_url
    ENV['EXTENSION_STORE_URL']
  end

  def options_url
    ENV['EXTENSION_OPTIONS_URL']
  end
end
