class User::DashboardController < User::BaseController
  
  # GET /dashboard
  def index
  end

  private
  
  def set_navs
    set_nav("user/dashboard")
  end
  
end

