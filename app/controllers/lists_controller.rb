class ListsController < ApplicationController
  
  before_action :select_user_application_list_from_params, only: [:show]
  before_action :raise_unless_visible_component, only: [:show]

  def show
  end

  private

  def list_params
    params.permit(:user_username, :application_name, :name_format)
  end

  def select_user_application_list_from_params
    @user = User.find_by(username: list_params[:user_username])
    @application = Application.find_by(name: list_params[:application_name], user: @user)
    @component = @list = List.find_by(name_format: list_params[:name_format], application: @application)
  end
end
