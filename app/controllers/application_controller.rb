class ApplicationController < ActionController::Base
  helper_method :current_user

  def raise_unless_visible_multiple
    if !ApplicationVisibilityPolicy.new.allowed_multiple?(@applications, current_user)
      raise ActiveRecord::RecordNotFound.new
    end
  end

  def raise_unless_visible
    if !ApplicationVisibilityPolicy.new.allowed?(@application, current_user)
      raise ActiveRecord::RecordNotFound.new
    end
  end

  def raise_unless_visible_component
    if !ComponentVisibilityPolicy.new.allowed?(@component, current_user)
      raise ActiveRecord::RecordNotFound.new
    end
  end
end
