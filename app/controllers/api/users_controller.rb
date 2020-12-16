module Api
  class UsersController < BaseController
    before_action :authenticate_user!

    def show
      render json: { email: current_user.email }
    end
  end
end
