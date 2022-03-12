require 'rails_helper'

RSpec.describe "Codes", type: :request do
  describe "GET /show" do

    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should show you your own codes" do
        app = create(:application, user: user)
        code = create(:code, application: app)
        get "/#{user.username}/#{app.name}/codes/#{code.name_format}"
        expect(response).to have_http_status(200)
      end

      it "Should not show you other users codes" do
        app_2 = create(:application, name: "app_2", user: user_2)
        code_2 = create(:code, title: "code 2", application: app_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/codes/#{code_2.name_format}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see other user codes" do
        app_2 = create(:application, name: "app_2", user: user_2)
        code_2 = create(:code, title: "code 2", application: app_2)
        get "/#{user_2.username}/#{app_2.name}/codes/#{code_2.name_format}"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /new" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should show you new code form in your own app" do
        app = create(:application, user: user)
        get "/#{user.username}/#{app.name}/codes/new"
        expect(response).to have_http_status(200)
      end

      it "Should not show you code form in other users app" do
        app_2 = create(:application, name: "app_2", user: user_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/codes/new"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see code form in other user apps" do
        app_2 = create(:application, name: "app_2", user: user_2)
        get "/#{user_2.username}/#{app_2.name}/codes/new"
        expect(response).to have_http_status(200)
      end
    end
  end
end
