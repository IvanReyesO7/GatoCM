class ApplicationController < ActionController::Base
  helper_method :current_user

  def raise_unless_visible
    if !ApplicationVisibilityPolicy.new.allowed?(@applications, current_user)
      raise ActiveRecord::RecordNotFound.new
    end
  end
end
