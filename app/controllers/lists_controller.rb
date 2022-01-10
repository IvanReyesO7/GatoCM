class ListsController < ApplicationController
  
  before_action :select_user_application_list_from_params, only: [:show]
  before_action :select_user_application_from_params, only: [:new, :create]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :raise_unless_visible, only: [:create, :new]

  def show
  end

  def new
    @list =  List.new
  end

  def create
    @list = List.create(
      name: list_params[:list][:name],
      application: @application
    )
    if @list.save
      redirect_to user_application_path(name: @application.name)
    else
      render :new
    end
  end

  private

  def list_params
    params.permit(:user_username, :application_name, :name_format, :authenticity_token, :commit, { list: [:name] })
  end

  def select_user_application_list_from_params
    @user = User.find_by!(username: list_params[:user_username])
    @application = Application.find_by!(name: list_params[:application_name], user: @user)
    @component = @list = List.find_by!(name_format: list_params[:name_format], application: @application)
  end

  def select_user_application_from_params
    @user = User.find_by!(username: list_params[:user_username])
    @application = Application.find_by!(name: list_params[:application_name], user: @user)
  end
end
