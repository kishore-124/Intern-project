# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base

  before_action :set_locale


  rescue_from CanCan::AccessDenied do |exception|
   redirect_to root_path
 flash[:notice] = exception.message
 end
  include Pagy::Backend
   protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404" }
    end
  end
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name
                                                         email
                                                        password
                                                         password_confirmation])
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?


  end

  def default_url_options(options ={})
    {locale: I18n.locale}
  end
end
