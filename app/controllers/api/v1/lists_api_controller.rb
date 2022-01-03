class Api::V1::ListsApiController < Api::Controller
  def all
    @user = User.find_by(username: list_params[:username])
    @app = Application.find_by(name: list_params[:application_name], user: @user)
  end

  def list_params
    params.permit(:api_token, :username, :application_name, :format)
  end
end