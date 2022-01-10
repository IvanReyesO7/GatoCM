class ItemsController < ApplicationController
  
  before_action :select_user_application_list_from_params, only: [:new, :create]
  before_action :raise_unless_visible, only: [:new, :create]

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(
      content:   item_params[:item][:content],
      list:      @list
    )
    p @item.valid?
    if @item.save
      redirect_to user_application_list_path(name_format: @list.name_format)
    else
      render :new
    end
  end

  private

  def item_params
    params.permit(:user_username, :application_name, :list_name_format, { item: [:content] }, :authenticity_token, :commit)
  end

  def select_user_application_list_from_params
    @user = User.find_by!(username: item_params[:user_username])
    @application = Application.find_by!(user: @user, name: item_params[:application_name])
    @list = List.find_by!(name_format: item_params[:list_name_format], application: @application)
  end
end
