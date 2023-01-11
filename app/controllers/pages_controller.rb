class PagesController < ApplicationController
  def home
    redirect_to user_applications_index_path(user_username: current_user.username) if current_user
  end
end
