class ComponentVisibilityPolicy
  def allowed?(component, user)
    component.application.user == user || user.admin?
  end
end