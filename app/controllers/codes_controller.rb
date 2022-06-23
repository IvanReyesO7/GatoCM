class CodesController < ApplicationController

  before_action :select_user_application_code_from_params, only: [:show, :destroy]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :select_user_application_from_params, only: [:new, :create, :render_raw]
  before_action :raise_unless_visible, only: [:create, :new, :destroy]
  before_action :check_read_token, only: [:render_raw]
  protect_from_forgery except: :render_raw

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
    begin
      @code = Code.find_by!(title: "#{codes_params[:title]}.#{codes_params[:format]}",
                            file_type: codes_params[:type],
                            application: @application)

      case @code.file_type
      when 'javascript'
        render_javascript
      when 'css'
        render_css
      when 'html'
        render_html
      else
        raise StandardError.new("File type not supported yet...")
      end
      # If rendering is succesfull, add +1 to the downloads count
      @code.increase_download_count!
    rescue => error
      render body: 'Not found', status: 404
    end
  end

  def render_javascript
    respond_to do |format|
      format.js { render partial: "codes/shared/file" }
    end
  end

  def render_css
    respond_to do |format|
      format.css { render partial: "codes/shared/file" }
    end
  end

  def render_html
    respond_to do |format|
      format.html { render partial: "codes/shared/file" }
    end
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
      render body: 'Not found', status: 404
    end
  end
end
