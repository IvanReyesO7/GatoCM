class ListVisibilityPolicy
  def allowed?(list, user)
    list.application.user == user || user.admin?
  end
end