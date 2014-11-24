class Admin::RolesController < Admin::BaseController
  
  before_filter :get_project
  skip_before_filter :set_navs, :parse_pagination_params
  
  # GET /admin/roles
  def index
    
    get_collections
    
    respond_to do |format|
      format.html # index.html.erb
      format.js {}
    end
  end

  # GET /admin/roles/1
  def show
    ## Creating the role object  
    @role = Role.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.js {}
    end
  end

  # GET /admin/roles/new
  def new
    ## Intitializing the role object 
    @role = Role.new
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.js {}
    end
  end

  # POST /admin/roles
  def create
    ## Creating the role object  
    @role = Role.new(params[:role].permit(:name))
    @member = User.find_by_id(params[:role][:member_id]) if params[:role] && params[:role][:member_id]
    @role.resource = @project
    
    ## Validating the data
    @role.valid?

    ## Check if the role is already added to this project
    project_users = @project.users
    if project_users.include?(@member)
      @role.errors.add(:member_id, "This user is already a member of this project.")
    end

    respond_to do |format|
      if @role.errors.blank?
        
        # Saving the role object
        @member.add_role @role.name, @project
        
        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Member")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to role_url(@role), notice: message
        }
        format.js {}
      else
        
        # Setting the flash message
        message = @role.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { render action: "new" }
        format.js {}
      end
    end
  end

  # DELETE /admin/roles/1
  def destroy
    ## Fetching the role
    @role = Role.find(params[:id])
    @member = User.find_by_id(params[:member_id]) if params[:member_id]
    @success = false

    ## Destroying the role
    if @member.roles.delete(@role)
      
      @success = true

      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "Member")
      store_flash_message(message, :success)

    end

    respond_to do |format|
      format.html { redirect_to admin_project_url(@project), notice: message}
      format.js {}
        
    end
  end

  private

  def get_project
    @project = Project.find_by_id(params[:project_id])
  end
  
  def get_collections
    # Fetching the roles
    relation = @current_user.roles.where("resource_id = #{@project.id} and resource_type = 'Project'")
    
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    
    @roles = relation.order("created_at desc").page(@current_page).per(@per_page)
    
    return true
    
  end
  
end
