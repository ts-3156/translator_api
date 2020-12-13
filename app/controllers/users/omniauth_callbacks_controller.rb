class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect user, event: :authentication
  end

  def failure
    logger.info "oauth failed: #{request.env['omniauth.error.type']}"
    redirect_to root_path
  end
end
