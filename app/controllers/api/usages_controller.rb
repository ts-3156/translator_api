module Api
  class UsagesController < BaseController

    before_action :register_trial_license

    def show
      if params[:license_key] && (license = License.find_by(key: params[:license_key]))
        limit30 = license.limited_chars(30)
        render json: {
          'day1' => license.translated_chars(1),
          'day7' => license.translated_chars(7),
          'day30' => license.translated_chars(30),
          'limit30' => limit30,
          'limit30_str' => limit30.to_s(:delimited)
        }
      else
        head :not_found
      end
    end
  end
end
