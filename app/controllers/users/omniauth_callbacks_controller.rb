class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in user, event: :authentication
    flash[:notice] = t('.success')
    redirect_to root_path(via: 'auth_success')
  end

  def failure
    flash[:alert] = t('.failure', reason: request.env['omniauth.error.type'])
    redirect_to root_path(via: 'auth_failure')
  end
end
