module Api
  class BaseController < ApplicationController
    def doesnt_have_subscription!
      return if !user_signed_in? || !current_user.has_subscription?
      render json: { message: 'You already have a subscription' }, status: :bad_request
    end
  end
end
