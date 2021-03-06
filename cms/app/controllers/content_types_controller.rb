class ContentTypesController < ApplicationController
  before_action :set_content_type, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /content_types
  # GET /content_types.json
  def index
  end

  # GET /content_types/1
  # GET /content_types/1.json
  def show
  end

  # GET /content_types/new
  def new
    @content_type = ContentType.new
  end

  # GET /content_types/1/edit
  def edit
  end

  # POST /content_types
  # POST /content_types.json
  def create
    @content_type = ContentType.new(permitted_params.content_type)
    @content_type.project = @project

    respond_to do |format|
      if @content_type.save
        format.html { redirect_to project_content_type_path(@project, @content_type), notice: 'Content type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @content_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @content_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /content_types/1
  # PATCH/PUT /content_types/1.json
  def update
    respond_to do |format|
      if @content_type.update(permitted_params.content_type)
        format.html { redirect_to project_content_type_path(@project, @content_type), notice: 'Content type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @content_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /content_types/1
  # DELETE /content_types/1.json
  def destroy
    @content_type.destroy
    respond_to do |format|
      format.html { redirect_to project_content_types_url( @project) }
      format.json { head :no_content }
    end
  end
  
  
  
  
  
  
  
  def sort
    nummer = 1
    
    if params[:content_element_type]
      @content_type = ContentType.find(params[:id])

      params[:content_element_type].each do |cet|
        @content_type.reorder_content_element_type :cet => cet, :position => nummer
        nummer = nummer + 1
      end
    
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content_type
      @content_type = ContentType.find(params[:id])
    end
    
    def set_project
      @content_types = @project.content_types
    end
end
