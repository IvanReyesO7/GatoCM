class CodesController < ApplicationController
  def show
    @user = User.find_by(username: codes_params[:user_username])
    @application = Application.find_by(user: @user, name: codes_params[:application_name])
    @code = Code.find_by(application: @application, name_format: codes_params[:name_format])
  end

  private

  def codes_params
    params.permit(:user_username, :application_name, :name_format)
  end
end
