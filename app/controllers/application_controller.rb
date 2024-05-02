class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name, :username, :email, :name, :image_url])
    devise_parameter_sanitizer.permit(:account_update, keys: [:display_name, :username, :name, :image_url])
  end
end
