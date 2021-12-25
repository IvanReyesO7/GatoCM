class ImagesController < ApplicationController
  def show
    @image = Image.find_by(name_format: images_params[:name_format])
  end

  private

  def images_params
    params.permit(:user_username, :application_name, :name_format)
  end
end
