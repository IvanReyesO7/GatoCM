class ApplicationApiAuthorizationPolicy
  def valid_api_token?(token, user)
    !token.nil? && user.api_token == token
  end
end