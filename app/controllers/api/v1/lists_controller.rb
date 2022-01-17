class Api::V1::ListsController < Api::Controller
  before_action :select_user_application_from_params, only: [:all, :items, :random]
  before_action :select_token_from_request, only: [:all, :items, :random]
  before_action :raise_unless_valid_api_token, only: [:all, :items, :random]

  def all
    @lists = @app.lists
  end

  def items
    @list = List.find_by!(name_format: list_params[:list_name_format], application: @app)
    @items = @list.items
  end

  def random
    @list = List.find_by!(name_format: list_params[:list_name_format], application: @app)
    @random = @list.items.sample
  end

  private

  def list_params
    params.permit(:api_token, :username, :application_name, :format, :list_name_format)
  end

  def select_user_application_from_params
    @user = User.find_by!(username: list_params[:username])
    @app = Application.find_by!(name: list_params[:application_name], user: @user)
  end

  def select_token_from_request
    @token = request.headers["Authorization"]
  end
end