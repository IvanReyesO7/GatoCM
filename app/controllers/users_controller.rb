class UsersController < ApplicationController
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to "/#{@user.username}/account_settings"
      flash[:alert] = "Success!"
    else
      flash[:alert] = "Sorry, something went wrong. #{@user.errors.full_messages[0]}"
      redirect_to user_user_account_settings_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end