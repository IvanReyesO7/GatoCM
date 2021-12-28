require 'rails_helper'

RSpec.describe "Applications", type: :request do

  let (:user) do
    create(:user)
  end

  let(:user_2) do
    create(:user, username: "user_2", email: "user_2@me.com")
  end

  let(:admin) do
    create(:admin_user, username: "admin", email: "admin@me.com")
  end

  describe "GET /index" do
    it "Should show user their created apps" do
      get user_applications_index_path(user_username: user.username)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show" do
    context "Normal users" do
      before do
        sign_in(user)
      end

      it "Should let you access your own apps" do
        app = create(:application, user: user)
        get "/#{user.username}/#{app.name}"
        expect(response).to have_http_status(200)
      end

      it "Should not let you access other users apps" do
        app_2 = create(:application, user: user_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should let an admin see other user's apps" do
        app_2 = create(:application, user: user_2)
        get "/#{user_2.username}/#{app_2.name}"
        expect(response).to have_http_status(200)
      end
    end
  end
end
