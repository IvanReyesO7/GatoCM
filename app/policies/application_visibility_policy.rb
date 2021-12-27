class ApplicationVisibilityPolicy
  def allowed?(applications, user)
    applications.all?{ |app| app.user == user } || user.admin?
  end
end