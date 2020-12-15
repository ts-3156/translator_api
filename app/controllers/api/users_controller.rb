module Api
  class UsersController < BaseController
    before_action :authenticate_user!

    def show
      license_key = current_user.license_keys.order(created_at: :desc).first&.key
      render json: { email: current_user.email, license_key: license_key }
    end
  end
end
