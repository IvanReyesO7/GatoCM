require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /new" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin01", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should allow you to see the item creation form" do
        app = create(:application, user: user)
        list = create(:list, application: app)
        get "/#{user.username}/#{app.name}/lists/#{list.name_format}/items/new"
        expect(response).to have_http_status(200)
      end

      it "Should not show you the item creation form in other's lists" do
        app_2 = create(:application, name: "app_2", user: user_2)
        list_2 = create(:list, name: "list 2", application: app_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/lists/#{list_2.name_format}/items/new"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "Admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow admins to see the item creation form on other's lists" do
        app_2 = create(:application, name: "app_2", user: user_2)
        list_2 = create(:list, name: "list 2", application: app_2)
        get "/#{user_2.username}/#{app_2.name}/lists/#{list_2.name_format}/items/new"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /create" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin01", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should allow you to create a item in your own list" do
        @app = create(:application, user: user)
        @list = create(:list, application: @app)
        post "/#{user.username}/#{@app.name}/lists/#{@list.name_format}/items",
        params: {
          application_name: @app.name,
          list_name_format: @list.name_format,
          user_username:    user.username,
          item:             { content: "Test" }
        }
        expect(response.status).to eq(302)
      end

      it "Should not allow you to create items in other users lists" do
        @app = create(:application, user: user_2)
        @list = create(:list, application: @app)
        expect do
          post "/#{user_2.username}/#{@app.name}/lists/#{@list.name_format}/items",
          params: {
            application_name: @app.name,
            list_name_format: @list.name_format,
            user_username:    user_2.username,
            item:             { content: "Test" }
          }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "Admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow admins to create items in other users lists" do
        @app = create(:application, user: user)
        @list = create(:list, application: @app)
        post "/#{user.username}/#{@app.name}/lists/#{@list.name_format}/items",
        params: {
          application_name: @app.name,
          list_name_format: @list.name_format,
          user_username:    user.username,
          item:             { content: "Test" }
        }
        expect(response.status).to eq(302)        
      end
    end
  end
end
