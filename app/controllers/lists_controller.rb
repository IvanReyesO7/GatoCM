require 'json'

class ListsController < ApplicationController
  before_action :select_user_application_list_from_params, only: [:show, :destroy]
  before_action :select_user_application_from_params, only: [:new, :create, :serve_items]
  before_action :raise_unless_visible_component, only: [:show]
  before_action :raise_unless_visible, only: [:create, :new, :destroy]
  before_action :check_read_token, only: [:serve_items]

  
  def show
  end

  def new
    @list =  List.new
  end

  def create
    @list = List.create(
      name: list_params[:list][:name],
      application: @application
    )
    if @list.save
      redirect_to user_application_path(name: @application.name)
    else
      render :new
    end
  end

  def destroy
    @list.items.destroy_all
    @list.destroy!

    redirect_to user_application_path(name: @application.name)
  end

  def import_items
    begin
      @list = List.find_by!(name_format: list_params["list_name_format"])
      content_type = list_params["list"]["uploaded_file"].content_type
      path = list_params["list"]["uploaded_file"].tempfile.path
      case content_type 
      when "application/x-yaml"
        items = YAML.load_file(path)["items"]
        parse_items_from_hash(items)
      when "application/json"
        file = File.read(path)
        items = JSON.parse(file)["items"]
        parse_items_from_hash(items)
      else
        raise StandardError.new("Content type not supported")
      end
    rescue => error
      flash[:alert] = "Something went wrong. #{error}"
      redirect_to user_application_list_path(name_format: list_params["list_name_format"])
    end
  end

  def import_succesfull
    flash[:alert] = "Success!"
    redirect_to user_application_list_path(name_format: list_params["list_name_format"])
  end

  def parse_items_from_hash(items)
    items.each { |item| Item.create!(list: @list, content: item) }
    import_succesfull
  end

  def serve_items
    begin
      @list = List.find_by!(name_format: list_params[:name_format], application: @application)
      @items = @list.items
    end
  end

  private

  def list_params
    params.permit(:user_username, :application_name, :list_name_format, :name_format, :authenticity_token, :commit, :read_token, { list: [:name, :uploaded_file] })
  end

  def select_user_application_list_from_params
    @user = User.find_by!(username: list_params[:user_username])
    @application = Application.find_by!(name: list_params[:application_name], user: @user)
    @component = @list = List.find_by!(name_format: list_params[:name_format], application: @application)
  end

  def select_user_application_from_params
    @user = User.find_by!(username: list_params[:user_username])
    @application = Application.find_by!(name: list_params[:application_name], user: @user)
  end

  def check_read_token
    token_passed = list_params[:read_token]
    unless @application.read_tokens.any? { |tkn| tkn.token == token_passed }
      raise ActiveRecord::RecordNotFound.new
    end
  end
end
