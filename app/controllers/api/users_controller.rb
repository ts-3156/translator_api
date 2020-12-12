module Api
  class UsersController < BaseController
    def index
      render json: [{ id: 1 }]
    end
  end
end
