module Api
  class LicensesController < BaseController

    rescue_from StandardError do |e|
      logger.warn "Unhandled exception: #{e.inspect}"
      logger.info e.backtrace.join("\n")
      render json: { message: 'Internal server error' }, status: :internal_server_error
    end

    def show
      if params[:uid] && params[:key] &&
        (user = User.find_by(uid: params[:uid])) &&
        (license = License.find_by(key: params[:key])) &&
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
