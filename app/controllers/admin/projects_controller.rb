class Admin::ProjectsController < Admin::BaseController
  
  #authorize_actions_for Item, :actions => {:index => :delete}
  
  # GET /admin/projects
  def index
    
    get_collections
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
      format.js {}
    end
  end

  # GET /admin/projects/1
  def show
    ## Creating the project object  
    @project = Project.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @project }
      format.js {}
    end
  end

  # GET /admin/projects/new
  def new
    ## Intitializing the project object 
    @project = Project.new
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @project }
      format.js {}
    end
  end

  # GET /admin/projects/1/edit
  def edit
    ## Fetching the project object 
    @project = Project.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @project }
      format.js {}
    end
  end

  # POST /admin/projects
  def create
    ## Creating the project object  
    @project = Project.new(params[:project].permit(:name, :description, :pretty_url))
    
    ## Validating the data
    @project.valid?
    
    respond_to do |format|
      if @project.errors.blank?
        
        # Saving the project object
        @project.save
        
        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Project")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to project_url(@project), notice: message
        }
        format.json { render json: @project, status: :created, location: @project }
        format.js {}
      else
        
        # Setting the flash message
        message = @project.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /admin/projects/1
  def update
    ## Fetching the project
    @project = Project.find(params[:id])
    
    ## Updating the @project object with params
    @project.assign_attributes(params[:project].permit(:name, :description, :pretty_url))
    
    ## Validating the data
    @project.valid?
    
    respond_to do |format|
      if @project.errors.blank?
        
        # Saving the project object
        @project.save
        
        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "Project")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to project_url(@project), notice: message 
        }
        format.json { head :no_content }
        format.js {}
        
      else
        
        # Setting the flash message
        message = @project.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { 
          render action: "edit" 
        }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        format.js {}
        
      end
    end
  end

  # DELETE /admin/projects/1
  def destroy
    ## Fetching the project
    @project = Project.find(params[:id])
    
    respond_to do |format|
      ## Destroying the project
      @project.destroy
      @project = Project.new
      
      # Fetch the projects to refresh ths list and details box
      get_collections
      @project = @projects.first if @projects and @projects.any?
      
      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "Project")
      store_flash_message(message, :success)
      
      format.html { 
        redirect_to projects_url notice: message
      }
      format.json { head :no_content }
      format.js {}
        
    end
  end

  private
  
  def set_navs
    set_nav("admin/projects")
  end
  
  def get_collections
    # Fetching the projects
    relation = Project.where("")
    @filters = {}
    
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    
    @projects = relation.order("name asc").page(@current_page).per(@per_page)
    
    ## Initializing the @project object so that we can render the show partial
    @project = @projects.first unless @project
    
    return true
    
  end
  
end
