class Api::Controller < ApplicationController
  def raise_unless_valid_api_token
    if !ApplicationApiAuthorizationPolicy.new.valid_api_token?(@token, @user)
      raise ActiveRecord::RecordNotFound.new
    end
  end
end