class ImagesController < ApplicationController
  def show
    @user = User.find_by(username: images_params[:user_username])
    @application = Application.find_by(user: @user, name: images_params[:application_name])
    @image = Image.find_by(application: @application ,name_format: images_params[:name_format])
  end

  private

  def images_params
    params.permit(:user_username, :application_name, :name_format)
  end
end
