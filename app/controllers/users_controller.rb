class UsersController < ApplicationController
  def update
    @user = current_user
    if @user.update(user_params)
      @user.reload
      redirect_to "/#{@user.username}/account_settings"
    else
      flash[:alert] = "Sorry, something went wrong."
      redirect_to user_user_account_settings_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end