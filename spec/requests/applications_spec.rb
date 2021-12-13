require 'rails_helper'

RSpec.describe "Applications", type: :request do

  let (:user) do
    user = create(:user)
  end

  describe "GET /index" do
    it "Should show user their created apps" do
      get user_applications_index_path(user_username: user.username)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show" do
    it "Should let you access your own apps" do
      app = create(:application, user: user)
      get "/#{user.username}/#{app.name}"
      expect(response).to have_http_status(200)
    end
  end
end
