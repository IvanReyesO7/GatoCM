class ApplicationsController < ApplicationController
  
  def index
    @user = User.find_by(username: application_params[:user_username])
    @applications = Application.where(user: @user)
  end

  def show
    if User.find_by(username: params[:user_username])
      @user = User.find_by(username: application_params[:user_username])
      @application = Application.find_by(name: application_params[:name], user: @user)
      @lists = @application.lists
      @images = @application.images
      @codes = @application.codes
    else
      raise ActiveRecord::RecordNotFound.new
    end
  end
  
  def new
    @application = Application.new
  end

  def create
    @application = Application.new(name: application_params)
    @application.valid? ? @Application.save! : raise
  end

  def update
    @application = Application.find_by(name: application_params[:name])
    @application.update(application_params)
  end

  def destroy
    @application = Application.find_by(name: application_params[:name])
    @application.destroy
    redirect_to user_applications_path
  end

  private

  def application_params
    params.permit(:name, :description, :user_id, :id, :user_username)
  end
end
