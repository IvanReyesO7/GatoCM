class ListsController < ApplicationController
  def show
    @user = User.find_by(username: list_params[:user_username])
    @application = Application.find_by(name: list_params[:application_name], user: @user)
    @list = List.find_by(name_format: list_params[:name_format], application: @application)
  end

  private

  def list_params
    params.permit(:user_username, :application_name, :name_format)
  end
end
