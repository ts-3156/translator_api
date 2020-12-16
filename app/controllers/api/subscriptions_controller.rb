module Api
  class SubscriptionsController < BaseController
    before_action :authenticate_user!

    def destroy
      subscription = current_user.subscriptions.find_by(id: params[:id])
      unless subscription.canceled?
        ApplicationRecord.transaction do
          subscription.cancel!
          current_user.license_keys.find_by(subscription_id: subscription.id)&.revoke!
        end
      end
      render json: { message: t('.destroy') }
    end
  end
end
