class User::TeamController < User::BaseController

  def index

    @per_page = "10"
    @users = User.where("client_id is null").order("name asc").page(@current_page).per(@per_page)

  end

  def show

    @user = User.find_by_username(params[:username])

  end

  private

	def set_navs
    set_nav("user/team")
	end

end