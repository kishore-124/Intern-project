class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
  end

  protected

  def sign_up(resource_name, resource)
  end
end