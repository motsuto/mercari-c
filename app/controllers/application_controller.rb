class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_category
  

  protected
  def set_category
    @parents  = Category.where(ancestry: nil)
  end

  private

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      Rails.application.credentials.basic_auth[:user] &&
      Rails.application.credentials.basic_auth[:pass]
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def after_sign_out_path_for(resource)
    done_users_path
  end
end
