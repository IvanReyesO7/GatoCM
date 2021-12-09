require 'rails_helper'

RSpec.describe "Applications", type: :request do

  let (:user) do
    user = create(:user)
  end

  describe "GET /index" do
    it "Should show user their created apps" do
      get user_applications_path(user_id: user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show" do
    it "Should let you access your own apps" do
      app = create(:application, user: user)
      get "/users/#{user.id}/applications/#{app.id}"
      expect(response).to have_http_status(200)
    end
  end
end
