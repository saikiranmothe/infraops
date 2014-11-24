class User::ProfileController < User::BaseController
  
  # GET /profile
  def index
  end

  private
  
  def set_navs
    set_nav("user/profile")
  end
  
end

