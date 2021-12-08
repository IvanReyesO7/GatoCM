class ApplicationsController < ApplicationController
  
  def index
    @user = current_user
    @applications = Application.where(user: @user)
  end

  def show
    if User.find(params[:user_id]) == current_user
      @application = Application.find(application_params[:id])
    end
  end
  
  def new
    @Application = Application.new
  end

  def create
    @Application = Application.new(application_params)
    @Application.valid? ? @Application.save! : raise
  end

  def update
  end

  def destroy
  end

  private

  def application_params
    params.permit(:name, :description, :user_id, :id)
  end
end
