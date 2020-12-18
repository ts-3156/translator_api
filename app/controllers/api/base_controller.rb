module Api
  class BaseController < ApplicationController

    private

    def register_trial_license
      if params[:license_key] && params[:license_key].match?(/\Alk_trial_\w{30,50}\z/) && !TrialLicense.exists?(key: params[:license_key])
        TrialLicense.create!(key: params[:license_key])
      end
    end

    def doesnt_have_subscription!
      return if !user_signed_in? || !current_user.has_subscription?
      render json: { message: 'You already have a subscription' }, status: :bad_request
    end
  end
end
