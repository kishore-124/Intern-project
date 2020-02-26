# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
 redirect_to root_path
 flash[:notice] = exception.message
 end
  include Pagy::Backend
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name
                                                         email
                                                        password
                                                         password_confirmation])
  end
end
