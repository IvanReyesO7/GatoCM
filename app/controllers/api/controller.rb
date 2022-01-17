class Api::Controller < ApplicationController
  def raise_unless_valid_api_token
    if !ApplicationApiAuthorizationPolicy.new.valid_api_token?(@token, @user)
      render json: {errors: [message: "403 Forbidden"]}, status: 403
    end
  end
end