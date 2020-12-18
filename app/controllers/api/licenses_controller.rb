module Api
  class LicensesController < BaseController

    rescue_from StandardError do |e|
      logger.warn "Unhandled exception: #{e.inspect}"
      logger.info e.backtrace.join("\n")
      render json: { message: 'Internal server error' }, status: :internal_server_error
    end

    def show
      if params[:uid] && params[:license_key] &&
        params[:license_key].match?(/\Alk_(free|pro)_\w{30,50}\z/) &&
        (user = User.find_by(uid: params[:uid])) &&
        (license = License.find_by(key: params[:license_key])) &&
        (access_token = GoogleOauth.new(refresh_token: user.credential.refresh_token).access_token) &&
        (uid = GoogleOauth.new(access_token: access_token).uid) &&
        user.uid == uid
        render json: { license.type => true }
      else
        render json: { message: 'Invalid uid or key' }, status: :bad_request
      end
    end
  end
end
