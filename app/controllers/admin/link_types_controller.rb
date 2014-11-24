class Admin::LinkTypesController < Admin::BaseController
  
  #authorize_actions_for Item, :actions => {:index => :delete}
  skip_before_filter :set_navs, :parse_pagination_params
  
  # GET /link_types
  def index
    
    get_collections
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @link_types }
      format.js {}
    end
  end

  # GET /link_types/1
  def show
    ## Creating the link_type object  
    @link_type = LinkType.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @link_type }
      format.js {}
    end
  end

  # GET /link_types/new
  def new
    ## Intitializing the link_type object 
    @link_type = LinkType.new
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @link_type }
      format.js {}
    end
  end

  # GET /link_types/1/edit
  def edit
    ## Fetching the link_type object 
    @link_type = LinkType.find(params[:id])
    
    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @link_type }
      format.js {}
    end
  end

  # POST /link_types
  def create
    ## Creating the link_type object  
    @link_type = LinkType.new(params[:link_type].permit(:name, :description, :url ,:theme, :button_text, :under_construction))
    
    ## Validating the data
    @link_type.valid?
    
    respond_to do |format|
      if @link_type.errors.blank?
        
        # Saving the link_type object
        @link_type.save
        
        # Setting the flash message
        message = translate("forms.created_successfully", :item => "Link Type")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_link_type_url(@link_type), notice: message
        }
        format.json { render json: @link_type, status: :created, location: @link_type }
        format.js {}
      else
        
        # Setting the flash message
        message = @link_type.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { render action: "new" }
        format.json { render json: @link_type.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /link_types/1
  def update
    ## Fetching the link_type
    @link_type = LinkType.find(params[:id])
    
    ## Updating the @link_type object with params
    @link_type.assign_attributes(params[:link_type].permit(:name, :description, :url ,:theme, :button_text, :under_construction))
    
    ## Validating the data
    @link_type.valid?
    
    respond_to do |format|
      if @link_type.errors.blank?
        
        # Saving the link_type object
        @link_type.save
        
        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "Link Type")
        store_flash_message(message, :success)
        
        format.html { 
          redirect_to admin_link_type_url(@link_type), notice: message 
        }
        format.json { head :no_content }
        format.js {}
        
      else
        
        # Setting the flash message
        message = @link_type.errors.full_messages.to_sentence
        store_flash_message(message, :alert)
        
        format.html { 
          render action: "edit" 
        }
        format.json { render json: @link_type.errors, status: :unprocessable_entity }
        format.js {}
        
      end
    end
  end

  # DELETE /link_types/1
  def destroy
    ## Fetching the link_type
    @link_type = LinkType.find(params[:id])
    
    respond_to do |format|
      ## Destroying the link_type
      @link_type.destroy
      @link_type = LinkType.new

      # Fetch the link_types to refresh ths list and details box
      get_collections
      @link_type = @link_types.first if @link_types and @link_types.any?
      
      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "Link Type")
      store_flash_message(message, :success)
      
      format.html { 
        redirect_to admin_link_types_url notice: message
      }
      format.json { head :no_content }
      format.js {}
        
    end
  end
  
  private
  
  def set_navs
    set_nav("admin/link_types")
  end
  
  def get_collections
    # Fetching the link_types
    relation = LinkType.where("")
    @filters = {}
    
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    
    @link_types = relation.order("name asc").page(@current_page).per(@per_page)
    
    ## Initializing the @link_type object so that we can render the show partial
    @link_type = @link_types.first unless @link_type
    
    return true
    
  end
  
end
