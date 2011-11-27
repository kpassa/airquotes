require File.expand_path('lib/authentication.rb')

class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authentication
  helper :layout

  helper_method :current_user

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      login_required
    else
      flash[:error] = "Acceso denegado."
      redirect_to root_url
    end
  end

end
