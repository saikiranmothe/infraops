class Admin::OsVersionsController < Admin::BaseController

  #authorize_actions_for Item, :actions => {:index => :delete}
  before_filter :get_os

  # GET /admin/os_versions
  def index

    get_collections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @os_versions }
      format.js {}
    end
  end

  # GET /admin/os_versions/1
  def show
    ## Creating the os_version object
    @os_version = OsVersion.find(params[:id])

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @os_version }
      format.js {}
    end
  end

  # GET /admin/os_versions/new
  def new
    ## Intitializing the os_version object
    @os_version = OsVersion.new(operating_system: @os)

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @os_version }
      format.js {}
    end
  end

  # GET /admin/os_versions/1/edit
  def edit
    ## Fetching the os_version object
    @os_version = OsVersion.find(params[:id])

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @os_version }
      format.js {}
    end
  end

  # POST /admin/os_versions
  def create
    ## Creating the os_version object
    @os_version = OsVersion.new(os_version_params)

    @os_version.operating_system = @os

    ## Validating the data
    @os_version.valid?

    respond_to do |format|
      if @os_version.errors.blank?

        # Saving the os_version object
        @os_version.save

        # Setting the flash message
        message = translate("forms.created_successfully", :item => "OsVersion")
        store_flash_message(message, :success)

        format.html {
          redirect_to os_version_url(@os_version), notice: message
        }
        format.json { render json: @os_version, status: :created, location: @os_version }
        format.js {}
      else

        # Setting the flash message
        message = @os_version.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html { render action: "new" }
        format.json { render json: @os_version.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /admin/os_versions/1
  def update
    ## Fetching the os_version
    @os_version = OsVersion.find(params[:id])

    ## Updating the @os_version object with params
    @os_version.assign_attributes(os_version_params)

    ## Validating the data
    @os_version.valid?

    respond_to do |format|
      if @os_version.errors.blank?

        # Saving the os_version object
        @os_version.save

        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "OsVersion")
        store_flash_message(message, :success)

        format.html {
          redirect_to os_version_url(@os_version), notice: message
        }
        format.json { head :no_content }
        format.js {}

      else

        # Setting the flash message
        message = @os_version.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html {
          render action: "edit"
        }
        format.json { render json: @os_version.errors, status: :unprocessable_entity }
        format.js {}

      end
    end
  end

  # DELETE /admin/os_versions/1
  def destroy
    ## Fetching the os_version
    @os_version = OsVersion.find(params[:id])

    respond_to do |format|
      ## Destroying the os_version
      @os_version.destroy
      @os_version = OsVersion.new

      # Fetch the os_versions to refresh ths list and details box
      get_collections
      @os_version = @os_versions.first if @os_versions and @os_versions.any?

      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "OsVersion")
      store_flash_message(message, :success)

      format.html {
        redirect_to os_versions_url notice: message
      }
      format.json { head :no_content }
      format.js {}

    end
  end

  private

  def set_navs
    set_nav("admin/os_versions")
  end

  def get_os
    @os = OperatingSystem.find_by_id(params[:os_id]) if params[:os_id]
  end

  def os_version_params
    params[:os_version].permit(:name, :version)
  end

  def get_collections
    # Fetching the os_versions
    relation = OsVersion.where("")
    @filters = {}

    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end

    @os_versions = relation.order("name asc").page(@current_page).per(@per_page)

    ## Initializing the @os_version object so that we can render the show partial
    @os_version = @os_versions.first unless @os_version

    return true

  end

end
