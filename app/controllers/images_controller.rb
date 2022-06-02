require 'open-uri'

class ImagesController < ApplicationController

  before_action :select_user_application_image_from_params, only: [:show, :destroy, :download]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :select_user_application_from_params, only: [:new, :create, :serve]
  before_action :raise_unless_visible, only: [:create, :new, :destroy]

  SUPPORTED_FORMATS = ["image/png", "image/jpeg", "image/jpg"]

  def show
  end

  def new
    @image = Image.new
  end

  def create
    begin
      file = images_params[:image][:photo]
      if  SUPPORTED_FORMATS.include?(file.content_type)
        image_decorated = ImageDecorator.new(file)
        uploader = image_decorated.upload_to_cloudinary
        @image = Image.create!(title: images_params[:image][:title],
                               application: @application,
                               url: uploader["secure_url"],
                               public_id: uploader["public_id"],
                               extension: image_decorated.extension,
                               file_type: image_decorated.extension)
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

  def download
    url = @image.url
    data = open(url).read
    send_data data, :disposition => 'attachment', :filename=>"#{@image.name_format}.#{@image.extension}"
  end

  def serve
    @image = Image.find_by!(application: @application ,name_format: params["image_name_format"])
    # If rendering is succesfull, add +1 to the downloads count
    @image.downloads += 1
    @image.save
    redirect_to @image.url
  end

  private

  def images_params
    params.permit(:user_username, :application_name, :name_format, :authenticity_token, :commit, :image_name_format, image: [:photo, :title])
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
