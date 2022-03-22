class ImagesController < ApplicationController

  before_action :select_user_application_image_from_params, only: [:show, :destroy, :download_image]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :select_user_application_from_params, only: [:new, :create]
  before_action :raise_unless_visible, only: [:create, :new, :destroy]

  SUPPORTED_FORMATS = ["image/png", "image/jpeg"]

  def show
  end

  def new
    @image = Image.new
  end

  def create
    begin
      content_type = images_params[:image][:photo].content_type
      if  SUPPORTED_FORMATS.include?(content_type)
        img_path = images_params[:image][:photo].tempfile.path
        uploader = Cloudinary::Uploader.upload(img_path)
        @image = Image.create!(title: images_params[:image][:title],
                               application: @application,
                               url: uploader["secure_url"],
                               public_id: uploader["public_id"])
        flash[:alert] = "Success!"
        redirect_to user_application_path(name: @application.name)
      else
        raise StandardError.new("Content type not supported")
      end
    rescue => error
      flash[:alert] = "Something went wrong. #{error}"
      redirect_to user_application_path(name: @application.name)
    end
  end

  def destroy
    @image.destroy!
    
    redirect_to user_application_path(name: @application.name)
  end

  def download_image
    raise
  end

  private

  def images_params
    params.permit(:user_username, :application_name, :name_format, :authenticity_token, :commit, image: [:photo, :title])
  end

  def select_user_application_image_from_params
    @user = User.find_by!(username: images_params[:user_username])
    @application = Application.find_by!(user: @user, name: images_params[:application_name])
    @component = @image = Image.find_by!(application: @application ,name_format: images_params[:name_format])
  end

  def select_user_application_from_params
    @user = User.find_by!(username: images_params[:user_username])
    @application = Application.find_by!(user: @user, name: images_params[:application_name])
  end
end
