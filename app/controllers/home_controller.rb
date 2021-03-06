class HomeController < ApplicationController
  def index
    if user_signed_in?
      @user = current_user
      @subscription = current_user.current_subscription
      @license = current_user.current_license

      set_message
    end
  end

  private

  def set_message
    if session.delete(:checkout_start)
      if params[:via] == 'checkout_success'
        if current_user.has_subscription?
          flash.now[:notice] = t('.checkout_success')
        else
          flash.now[:alert] = t('.checkout_cancel')
        end
      elsif params[:via] == 'checkout_cancel'
        flash.now[:alert] = t('.checkout_cancel')
      end
    end
  end
end
