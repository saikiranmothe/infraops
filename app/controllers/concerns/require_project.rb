module Concerns
  module RequireProject
    extend ActiveSupport::Concern

    def require_project
      @project = Project.find_by_id(params[:project_id]) if params[:project_id]
    end
  end
end