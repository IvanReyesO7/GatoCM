require 'open-uri'

class ImagesController < ApplicationController

  before_action :select_user_application_image_from_params, only: [:show, :destroy, :download]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :select_user_application_from_params, only: [:new, :create, :serve]
  before_action :raise_unless_visible, only: [:create, :new, :destroy]
  before_action :check_read_token, only: [:serve]
  before_action :set_dashboard

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
    @image.increase_download_count!
  end

  def serve
    begin
      @image = Image.find_by!(application: @application ,name_format: params[:name_format])
      # If rendering is succesfull, add +1 to the downloads count
      @image.increase_download_count!
      redirect_to @image.url
    rescue => error
      render body: 'Not found', status: 404
    end
  end

  private

  def images_params
    params.permit(:user_username, :read_token, :application_name, :name_format, :authenticity_token, :commit, :image_name_format, image: [:photo, :title])
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

  def check_read_token
    token_passed = images_params[:read_token]
    unless @application.read_tokens.any? { |tkn| tkn.token == token_passed }
      raise ActiveRecord::RecordNotFound.new
    end
  end
end
