class User::SettingsController < User::BaseController
  
  # GET /settings
  def index
  end

  private
  
  def set_navs
    set_nav("user/settings")
  end
  
end

