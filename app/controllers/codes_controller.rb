class CodesController < ApplicationController

  before_action :select_user_application_code_from_params, only: [:show]
  before_action :raise_unless_visible_component, only: [:show]

  def show
  end

  def new
    @code = Code.new
  end

  private

  def codes_params
    params.permit(:user_username, :application_name, :name_format)
  end

  def select_user_application_code_from_params
    @user = User.find_by(username: codes_params[:user_username])
    @application = Application.find_by(user: @user, name: codes_params[:application_name])
    @component = @code = Code.find_by(application: @application, name_format: codes_params[:name_format])
  end
end
