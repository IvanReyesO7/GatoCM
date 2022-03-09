class ImagesController < ApplicationController

  before_action :select_user_application_image_from_params, only: [:show]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :select_user_application_from_params, only: [:new]

  def show
  end

  def new
    @image = Image.new
  end

  def create
    raise
  end

  private

  def images_params
    params.permit(:user_username, :application_name, :name_format)
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
