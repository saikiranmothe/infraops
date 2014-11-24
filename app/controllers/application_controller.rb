class ApplicationController < ActionController::Base

  protect_from_forgery

  include ParamsParserHelper
  include FlashHelper
  include NavigationHelper
  include ActionController::HttpAuthentication::Token::ControllerMethods

  ## This filter method is used to fetch current user
  before_filter :current_user

  def redirect_to_appropriate_page_after_sign_in
    if @current_user
      redirect_to user_dashboard_url
    else
      redirect_to user_sign_in_url
    end
  end

  def redirect_to_appropriate_page_if_signed_in
    redirect_to user_dashboard_url if @current_user
  end

  def current_user
    # Check if the user exists with the auth token present in session
    @current_user = User.find_by_id(session[:id])
    @current_admin = @current_user if @current_user and (@current_user.is_super_admin? || @current_user.is_admin?)
  end

  def require_user
    current_user
    unless @current_user
      @heading = translate("authentication.error")
      @alert = translate("authentication.permission_denied")
      store_flash_message("#{@heading}: #{@alert}", :errors)
      redirect_to user_sign_in_url
    end
  end

  def require_admin
    current_user
    unless @current_admin
      @heading = translate("authentication.error")
      @alert = translate("authentication.permission_denied")
      store_flash_message("#{@heading}: #{@alert}", :errors)
      redirect_to user_sign_in_url
    end
  end

end
