class ApplicationVisibilityPolicy
  def allowed_multiple?(applications, user)
    applications.all?{ |app| app.user == user } || user.admin?
  end

  def allowed?(application, user)
    application.user == user || user.admin?
  end
end