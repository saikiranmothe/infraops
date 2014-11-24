class Admin::DepartmentsController < Admin::BaseController
  
  #authorize_actions_for Item, :actions => {:index => :delete}
  
  # GET /departments
  # GET /departments.js
  # GET /departments.json
  def index
    
    get_collections
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @departments }
      format.js {}
    end
  end

  # GET /departments/1
  # GET /departments/1.js
  # GET /departments/1.json
  def show
    ## Creating the department object  
    @department = Department.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @department }
      format.js {}
    end
  end

  # GET /departments/new
  # GET /departments/new.json
  def new
    ## Intitializing the department object 
    @department = Department.new
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @department }
      format.js {}
    end
  end

  # GET /departments/1/edit
  def edit
    ## Fetching the department object 
    @department = Department.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @department }
      format.js {}
    end
  end

  # POST /departments
  # POST /departments.js
  # POST /departments.json
  def create
    ## Creating the department object  
    @department = Department.new(params[:department].permit(:name, :description))
    
    ## Validating the data
    @department.valid?
    
    respond_to do |format|
      if @department.errors.blank?
        
        # Saving the department object
        @department.save
        
        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Department")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_department_url(@department), notice: message
        }
        format.json { render json: @department, status: :created, location: @department }
        format.js {}
      else
        
        # Setting the flash message
        message = @department.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { render action: "new" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /departments/1
  def update
    ## Fetching the department
    @department = Department.find(params[:id])
    
    ## Updating the @department object with params
    @department.assign_attributes(params[:department].permit(:name, :description))
    
    ## Validating the data
    @department.valid?
    
    respond_to do |format|
      if @department.errors.blank?
        
        # Saving the department object
        @department.save
        
        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "Department")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_department_url(@department), notice: message 
        }
        format.json { head :no_content }
        format.js {}
        
      else
        
        # Setting the flash message
        message = @department.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { 
          render action: "edit" 
        }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js {}
        
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.js
  # DELETE /departments/1.json
  def destroy
    ## Fetching the department
    @department = Department.find(params[:id])
    
    respond_to do |format|
      ## Destroying the department
      @department.destroy
      @department = Department.new

      # Fetch the departments to refresh ths list and details box
      get_collections
      @department = @departments.first if @departments and @departments.any?
      
      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "Department")
      store_flash_message(message, :success)
      
      format.html { 
        redirect_to admin_departments_url notice: message
      }
      format.json { head :no_content }
      format.js {}
        
    end
  end
  
  private
  
  def set_navs
    set_nav("admin/departments")
  end
  
  def get_collections
    # Fetching the departments
    relation = Department.where("")
    @filters = {}
    
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    
    @departments = relation.order("name asc").page(@current_page).per(@per_page)
    
    ## Initializing the @department object so that we can render the show partial
    @department = @departments.first unless @department
    
    return true
    
  end
  
end
