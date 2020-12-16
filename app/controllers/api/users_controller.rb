module Api
  class UsersController < BaseController
    before_action :authenticate_user!

    def show
      render json: { email: current_user.email, license_key: current_user.active_license_key&.key }
    end
  end
end
