class Api::V1::CodesController < Api::Controller
  before_action :select_user_application_from_params, only: [:render_raw]
  before_action :select_token_from_request, only: [:render_raw]
  before_action :raise_unless_valid_api_token, only: [:render_raw]

  def render_raw
    render body: 'Not found bitch', status: 404
  end

  private

  def code_params
    params.permit(:api_token, :username, :application_name, :format, :code_name_format)
  end

  def select_user_application_from_params
    @user = User.find_by!(username: code_params[:username])
    @app = Application.find_by!(name: code_params[:application_name], user: @user)
  end

  def select_token_from_request
    @token = request.headers["Authorization"]
  end
end