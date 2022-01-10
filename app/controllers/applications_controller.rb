class ApplicationsController < ApplicationController
  before_action :select_user_and_applications_from_params, only: [:index]
  before_action :select_user_and_application_from_params, only: [:show]
  before_action :raise_unless_visible_multiple, only: [:index]
  before_action :raise_unless_visible, only: [:show]
  
  def index
  end

  def show
    @lists = @application.lists
    @images = @application.images
    @codes = @application.codes
  end
  
  def new
    @application = Application.new
  end

  def create
    @application = Application.new(name: application_params, user: current_user)
    @application.valid? ? @Application.save! : raise
  end

  def update
    @application = Application.find_by!(name: application_params[:name])
    @application.update(application_params)
  end

  def destroy
    @application = Application.find_by!(name: application_params[:name])
    @application.destroy
    redirect_to user_applications_path
  end

  private

  def application_params
    params.permit(:name, :description, :user_id, :id, :user_username)
  end

  def select_user_and_applications_from_params
    @user = User.find_by!(username: application_params[:user_username])
    @applications = Application.where(user: @user)
  end

  def select_user_and_application_from_params
    @user = User.find_by!(username: application_params[:user_username])
    @application = Application.find_by!(name: application_params[:name], user: @user)
  end
end
