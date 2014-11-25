class Admin::OperatingSystemsController < Admin::BaseController

  #authorize_actions_for Item, :actions => {:index => :delete}

  # GET /operating_systems
  # GET /operating_systems.js
  # GET /operating_systems.json
  def index

    get_collections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @operating_systems }
      format.js {}
    end
  end

  # GET /operating_systems/1
  # GET /operating_systems/1.js
  # GET /operating_systems/1.json
  def show
    ## Creating the operating_system object
    @operating_system = OperatingSystem.find(params[:id])

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @operating_system }
      format.js {}
    end
  end

  # GET /operating_systems/new
  # GET /operating_systems/new.json
  def new
    ## Intitializing the operating_system object
    @operating_system = OperatingSystem.new

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @operating_system }
      format.js {}
    end
  end

  # GET /operating_systems/1/edit
  def edit
    ## Fetching the operating_system object
    @operating_system = OperatingSystem.find(params[:id])

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @operating_system }
      format.js {}
    end
  end

  # POST /operating_systems
  # POST /operating_systems.js
  # POST /operating_systems.json
  def create
    ## Creating the operating_system object
    @operating_system = OperatingSystem.new(os_params)

    ## Validating the data
    @operating_system.valid?

    respond_to do |format|
      if @operating_system.errors.blank?

        # Saving the operating_system object
        @operating_system.save

        # Setting the flash message
        message = translate("forms.created_successfully", :item => "OperatingSystem")
        store_flash_message(message, :success)

        format.html {
          redirect_to admin_operating_system_url(@operating_system), notice: message
        }
        format.json { render json: @operating_system, status: :created, location: @operating_system }
        format.js {}
      else

        # Setting the flash message
        message = @operating_system.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html { render action: "new" }
        format.json { render json: @operating_system.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /operating_systems/1
  def update
    ## Fetching the operating_system
    @operating_system = OperatingSystem.find(params[:id])

    ## Updating the @operating_system object with params
    @operating_system.assign_attributes(os_params)

    ## Validating the data
    @operating_system.valid?

    respond_to do |format|
      if @operating_system.errors.blank?

        # Saving the operating_system object
        @operating_system.save

        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "OperatingSystem")
        store_flash_message(message, :success)

        format.html {
          redirect_to admin_operating_system_url(@operating_system), notice: message
        }
        format.json { head :no_content }
        format.js {}

      else

        # Setting the flash message
        message = @operating_system.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html {
          render action: "edit"
        }
        format.json { render json: @operating_system.errors, status: :unprocessable_entity }
        format.js {}

      end
    end
  end

  # DELETE /operating_systems/1
  # DELETE /operating_systems/1.js
  # DELETE /operating_systems/1.json
  def destroy
    ## Fetching the operating_system
    @operating_system = OperatingSystem.find(params[:id])

    respond_to do |format|
      ## Destroying the operating_system
      @operating_system.destroy
      @operating_system = OperatingSystem.new

      # Fetch the operating_systems to refresh ths list and details box
      get_collections
      @operating_system = @operating_systems.first if @operating_systems and @operating_systems.any?

      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "OperatingSystem")
      store_flash_message(message, :success)

      format.html {
        redirect_to admin_operating_systems_url notice: message
      }
      format.json { head :no_content }
      format.js {}

    end
  end

  private

  def set_navs
    set_nav("admin/operating_systems")
  end

  def os_params
    params[:operating_system].permit(:name, :short_name, :description)
  end

  def get_collections
    # Fetching the operating_systems
    relation = OperatingSystem.where("")
    @filters = {}

    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end

    @operating_systems = relation.order("name asc").page(@current_page).per(@per_page)

    ## Initializing the @operating_system object so that we can render the show partial
    @operating_system = @operating_systems.first unless @operating_system

    return true

  end

end
