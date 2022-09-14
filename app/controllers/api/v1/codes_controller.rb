class Api::V1::CodesController < Api::Controller
  before_action :select_user_application_from_params, only: [:render_raw]
  before_action :select_token_from_request, only: [:render_raw]
  before_action :raise_unless_valid_api_token, only: [:render_raw]
  protect_from_forgery except: :render_raw


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
    params.permit(:api_token, :username, :application_name, :format,
                  :code_name_format, :type, :title)
  end

  def select_user_application_from_params
    @user = User.find_by!(username: codes_params[:username])
    @application = Application.find_by!(name: codes_params[:application_name], user: @user)
  end

  def select_token_from_request
    @token = request.headers["Authorization"]
  end
end