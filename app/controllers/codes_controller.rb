class CodesController < ApplicationController

  before_action :select_user_application_code_from_params, only: [:show, :destroy]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :select_user_application_from_params, only: [:new, :create, :render_raw]
  before_action :raise_unless_visible, only: [:create, :new, :destroy]
  before_action :check_read_token, only: [:render_raw]

  def show
  end

  def new
    @code = Code.new
  end

  def create
    begin
      file = codes_params["code"]["file"]
      file_decorated = FileDecorator.new(file)
      @code = Code.create!( title: file_decorated.name,
                            content: file_decorated.content,
                            file_type: file_decorated.type,
                            extension: file_decorated.extension,
                            application: @application )
      flash[:alert] = "Success!"
      redirect_to user_application_path(name: @application.name)
    rescue => error
      flash[:alert] = "Something went wrong. #{error}"
      redirect_to user_application_path(name: @application.name)
    end
  end

  def destroy
    @code.destroy!

    redirect_to user_application_path(name: @application.name)
  end

  def render_raw
    raise
  end

  private

  def codes_params
    params.permit(:user_username, :application_name, :name_format, 
                  :authenticity_token, :commit, :read_token, :type,
                  :title, :format, code: [:file, :title])
  end

  def select_user_application_code_from_params
    @user = User.find_by!(username: codes_params[:user_username])
    @application = Application.find_by!(user: @user, name: codes_params[:application_name])
    @component = @code = Code.find_by!(application: @application, name_format: codes_params[:name_format])
  end

  def select_user_application_from_params
    @user = User.find_by!(username: codes_params[:user_username])
    @application = Application.find_by!(user: @user, name: codes_params[:application_name])
  end

  def check_read_token
    token_passed = codes_params[:read_token]
    unless @application.read_tokens.any? { |tkn| tkn.token == token_passed }
      raise ActiveRecord::RecordNotFound.new
    end
  end
end
