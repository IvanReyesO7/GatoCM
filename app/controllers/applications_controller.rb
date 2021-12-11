class ApplicationsController < ApplicationController
  
  def index
    @user = current_user
    @applications = Application.where(user: @user)
  end

  def show
    if User.find_by(username: params[:user_username])
      @application = Application.find(application_params[:id])
    else
      raise ActiveRecord::RecordNotFound.new
    end
  end
  
  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    @application.valid? ? @Application.save! : raise
  end

  def update
    @application = Application.find(application_params[:id])
    @application.update(application_params)
  end

  def destroy
    @application = Application.find(application_params[:id])
    @application.destroy
    redirect_to user_applications_path
  end

  private

  def application_params
    params.permit(:name, :description, :user_id, :id, :username)
  end
end
