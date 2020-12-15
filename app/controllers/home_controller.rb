class HomeController < ApplicationController
  def index
    @user = current_user
    set_checkout_message
  end

  private

  def set_checkout_message
    if session.delete(:checkout_start)
      if params[:via] == 'checkout_success'
        flash.now[:notice] = t('.checkout_success')
      elsif params[:via] == 'checkout_cancel'
        flash.now[:alert] = t('.checkout_cancel')
      end
    end
  end
end
