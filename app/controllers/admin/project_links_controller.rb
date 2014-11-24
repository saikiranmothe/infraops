class Admin::ProjectLinksController < ApplicationController
  
  #authorize_actions_for Item, :actions => {:index => :delete}
  before_filter :get_project
  
  # GET /project_links
  def index
    
    get_collections
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_links }
      format.js {}
    end
  end

  # GET /project_links/1
  def show
    ## Creating the project_link object  
    @project_link = ProjectLink.find(params[:id])
    @link_type = @project_link.link_type
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @project_link }
      format.js {}
    end
  end

  # GET /project_links/new
  def new
    ## Intitializing the project_link object 
    @project_link = ProjectLink.new
    @link_type = @project_link.link_type
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @project_link }
      format.js {}
    end
  end

  # GET /project_links/1/edit
  def edit
    ## Fetching the project_link object 
    @project_link = ProjectLink.find(params[:id])
    @link_type = @project_link.link_type
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @project_link }
      format.js {}
    end
  end

  # POST /project_links
  # POST /project_links.js
  # POST /project_links.json
  def create
    ## Creating the project_link object  
    @project_link = ProjectLink.new(params[:project_link].permit(:url, :link_type_id, :under_construction))
    @project_link.project = @project

    ## Validating the data
    @project_link.valid?
    
    respond_to do |format|
      if @project_link.errors.blank?
        
        # Saving the project_link object
        @project_link.save
        
        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Project Link")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_project_project_link_url(@project_link), notice: message
        }
        format.json { render json: @project_link, status: :created, location: @project_link }
        format.js {}
      else
        
        # Setting the flash message
        message = @project_link.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { render action: "new" }
        format.json { render json: @project_link.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /project_links/1
  def update
    ## Fetching the project_link
    @project_link = ProjectLink.find(params[:id])
    
    ## Updating the @project_link object with params
    @project_link.assign_attributes(params[:project_link].permit(:url, :link_type_id, :under_construction))
    
    ## Validating the data
    @project_link.valid?
    
    respond_to do |format|
      if @project_link.errors.blank?
        
        # Saving the project_link object
        @project_link.save
        
        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "Project Link")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_project_project_link_url(@project_link), notice: message 
        }
        format.json { head :no_content }
        format.js {}
        
      else
        
        # Setting the flash message
        message = @project_link.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { 
          render action: "edit" 
        }
        format.json { render json: @project_link.errors, status: :unprocessable_entity }
        format.js {}
        
      end
    end
  end

  # DELETE /project_links/1
  def destroy
    ## Fetching the project_link
    @project_link = ProjectLink.find(params[:id])
    @success = false

    ## Destroying the role
    if @project_link.destroy
      
      @success = true

    else

      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "Project Link")
      store_flash_message(message, :success)

    end

    respond_to do |format|
      format.html { redirect_to admin_project_url(@project), notice: message}
      format.js {}
        
    end
    
  end
  
  private
  
  def set_navs
    set_nav("admin/projects")
  end

  def get_project
    @project = Project.find_by_id(params[:project_id])
  end
  
  def get_collections
    # Fetching the project_links
    relation = @project.project_links.where("project_id = #{@project.id}")
    
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    
    @project_links = relation.order("created_at desc").page(@current_page).per(@per_page)
    
    ## Initializing the @project_link object so that we can render the show partial
    @project_link = @project_links.first unless @project_link
    
    return true
    
  end
  
end
