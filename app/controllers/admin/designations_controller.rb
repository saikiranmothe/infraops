class Admin::DesignationsController < Admin::BaseController
  
  #authorize_actions_for Item, :actions => {:index => :delete}
  
  # GET /designations
  def index
    
    get_collections
    
    respond_to do |format|
      format.html # index.html.erb
      format.js {}
    end
  end

  # GET /designations/1
  def show
    ## Creating the designation object  
    @designation = Designation.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.js {}
    end
  end

  # GET /designations/new
  # GET /designations/new.json
  def new
    ## Intitializing the designation object 
    @designation = Designation.new
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.js {}
    end
  end

  # GET /designations/1/edit
  def edit
    ## Fetching the designation object 
    @designation = Designation.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.js {}
    end
  end

  # POST /designations
  def create
    ## Creating the designation object  
    @designation = Designation.new(params[:designation].permit(:title, :responsibilities))
    
    ## Validating the data
    @designation.valid?
    
    respond_to do |format|
      if @designation.errors.blank?
        
        # Saving the designation object
        @designation.save
        
        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Designation")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_designation_url(@designation), notice: message
        }
        format.json { render json: @designation, status: :created, location: @designation }
        format.js {}
      else
        
        # Setting the flash message
        message = @designation.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { render action: "new" }
        format.json { render json: @designation.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /designations/1
  # PUT /designations/1.js
  def update
    ## Fetching the designation
    @designation = Designation.find(params[:id])
    
    ## Updating the @designation object with params
    @designation.assign_attributes(params[:designation].permit(:title, :responsibilities))
    
    ## Validating the data
    @designation.valid?
    
    respond_to do |format|
      if @designation.errors.blank?
        
        # Saving the designation object
        @designation.save
        
        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "Designation")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_designation_url(@designation), notice: message 
        }
        format.json { head :no_content }
        format.js {}
        
      else
        
        # Setting the flash message
        message = @designation.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { 
          render action: "edit" 
        }
        format.json { render json: @designation.errors, status: :unprocessable_entity }
        format.js {}
        
      end
    end
  end

  # DELETE /designations/1
  # DELETE /designations/1.js
  # DELETE /designations/1.json
  def destroy
    ## Fetching the designation
    @designation = Designation.find(params[:id])
    
    respond_to do |format|
      ## Destroying the designation
      @designation.destroy
      @designation = Designation.new

      # Fetch the designations to refresh ths list and details box
      get_collections
      @designation = @designations.first if @designations and @designations.any?
      
      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "Designation")
      store_flash_message(message, :success)
      
      format.html { 
        redirect_to admin_designations_url notice: message
      }
      format.json { head :no_content }
      format.js {}
        
    end
  end
  
  private
  
  def set_navs
    set_nav("admin/designations")
  end
  
  def get_collections
    # Fetching the designations
    relation = Designation.where("")
    @filters = {}
    
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    
    @designations = relation.order("title asc").page(@current_page).per(@per_page)
    
    ## Initializing the @designation object so that we can render the show partial
    @designation = @designations.first unless @designation
    
    return true
    
  end
  
end
