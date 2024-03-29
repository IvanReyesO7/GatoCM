class AccountSettingsController < ApplicationController
  before_action :select_user_from_params, only:[:show]
  before_action :raise_unless_logged_in, only:[:show]

  def show
  end

  private
  def account_settings_params
    params.permit(:user_username)
  end

  def select_user_from_params
    @user = User.find_by!(username: account_settings_params[:user_username])
  end

  def raise_unless_logged_in
    raise if current_user != @user && !current_user.admin?
  end
end