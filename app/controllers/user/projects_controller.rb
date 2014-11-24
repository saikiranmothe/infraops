class User::ProjectsController < User::BaseController

	def show
		@project = Project.find_by_pretty_url(params[:pretty_url])
	end

	private

	def set_navs
		set_nav("user/projects")
	end

end
