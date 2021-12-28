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

    before do
      sign_in(user)
    end
    
    it "Should let you access your own apps" do
      app = create(:application, user: user)
      get "/#{user.username}/#{app.name}"
      expect(response).to have_http_status(200)
    end

    it "Should not let you access other users apps" do
      user_2 = create(:user, username: "user_2", email: "user_2@me.com")
      app_2 = create(:application, user: user_2)
      expect do 
        get "/#{user_2.username}/#{app_2.name}"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
