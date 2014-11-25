class Admin::AwsInstanceTypesController < Admin::BaseController

  #authorize_actions_for Item, :actions => {:index => :delete}

  # GET /aws_instance_types
  def index

    get_collections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @aws_instance_types }
      format.js {}
    end
  end

  # GET /aws_instance_types/1
  def show
    ## Creating the aws_instance_type object
    @aws_instance_type = AwsInstanceType.find(params[:id])

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @aws_instance_type }
      format.js {}
    end
  end

  # GET /aws_instance_types/new
  def new
    ## Intitializing the aws_instance_type object
    @aws_instance_type = AwsInstanceType.new

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @aws_instance_type }
      format.js {}
    end
  end

  # GET /aws_instance_types/1/edit
  def edit
    ## Fetching the aws_instance_type object
    @aws_instance_type = AwsInstanceType.find(params[:id])

    respond_to do |format|
      format.html { get_collections and render :index }
      format.json { render json: @aws_instance_type }
      format.js {}
    end
  end

  # POST /aws_instance_types
  def create
    ## Creating the aws_instance_type object
    @aws_instance_type = AwsInstanceType.new(aws_instance_type_params)

    ## Validating the data
    @aws_instance_type.valid?

    respond_to do |format|
      if @aws_instance_type.errors.blank?

        # Saving the aws_instance_type object
        @aws_instance_type.save

        # Setting the flash message
        message = translate("forms.created_successfully", :item => "AwsInstanceType")
        store_flash_message(message, :success)

        format.html {
          redirect_to admin_aws_instance_type_url(@aws_instance_type), notice: message
        }
        format.json { render json: @aws_instance_type, status: :created, location: @aws_instance_type }
        format.js {}
      else

        # Setting the flash message
        message = @aws_instance_type.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html { render action: "new" }
        format.json { render json: @aws_instance_type.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /aws_instance_types/1
  # PUT /aws_instance_types/1.js
  # PUT /aws_instance_types/1.json
  def update
    ## Fetching the aws_instance_type
    @aws_instance_type = AwsInstanceType.find(params[:id])

    ## Updating the @aws_instance_type object with params
    @aws_instance_type.assign_attributes(aws_instance_type_params)

    ## Validating the data
    @aws_instance_type.valid?

    respond_to do |format|
      if @aws_instance_type.errors.blank?

        # Saving the aws_instance_type object
        @aws_instance_type.save

        # Setting the flash message
        message = translate("forms.updated_successfully", :item => "AwsInstanceType")
        store_flash_message(message, :success)

        format.html {
          redirect_to admin_aws_instance_type_url(@aws_instance_type), notice: message
        }
        format.json { head :no_content }
        format.js {}

      else

        # Setting the flash message
        message = @aws_instance_type.errors.full_messages.to_sentence
        store_flash_message(message, :alert)

        format.html {
          render action: "edit"
        }
        format.json { render json: @aws_instance_type.errors, status: :unprocessable_entity }
        format.js {}

      end
    end
  end

  # DELETE /aws_instance_types/1
  # DELETE /aws_instance_types/1.js
  # DELETE /aws_instance_types/1.json
  def destroy
    ## Fetching the aws_instance_type
    @aws_instance_type = AwsInstanceType.find(params[:id])

    respond_to do |format|
      ## Destroying the aws_instance_type
      @aws_instance_type.destroy
      @aws_instance_type = AwsInstanceType.new

      # Fetch the aws_instance_types to refresh ths list and details box
      get_collections
      @aws_instance_type = @aws_instance_types.first if @aws_instance_types and @aws_instance_types.any?

      # Setting the flash message
      message = translate("forms.destroyed_successfully", :item => "AwsInstanceType")
      store_flash_message(message, :success)

      format.html {
        redirect_to admin_aws_instance_types_url notice: message
      }
      format.json { head :no_content }
      format.js {}

    end
  end

  private

  def set_navs
    set_nav("admin/aws_instance_types")
  end

  def get_collections
    # Fetching the aws_instance_types
    relation = AwsInstanceType.where("")
    @filters = {}

    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end

    @aws_instance_types = relation.order("name asc").page(@current_page).per(@per_page)

    ## Initializing the @aws_instance_type object so that we can render the show partial
    @aws_instance_type = @aws_instance_types.first unless @aws_instance_type

    return true

  end

  def aws_instance_type_params
    params.require(:aws_instance_type).permit(:name, :short_name, :description)
  end

end
