class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :update, :destroy]

  # GET /images
  def index
    @images = Image.all(params[:user_id], params[:options] || {})

    render json: @images
  end

  # GET /images/1
  def show
    send_file "./uploads/#{@image.id}/#{@image.file_name}", type: @image.content_type, disposition: 'inline'
  end

  # POST /images
  def create
    @image = Image.new(image_params)

    if @image.upload
      render json: @image, status: :created
    else
      render json: {status: :unprocessable_entity}
    end
  end

  # PATCH/PUT /images/1
  # def update
  #   if @image.update(image_params)
  #     render json: @image
  #   else
  #     render json: @image.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /images/1
  def destroy
    @image.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def image_params
      params.permit(:user_id, :image)
    end

    def image_url
      @image.image.url
    end
end
