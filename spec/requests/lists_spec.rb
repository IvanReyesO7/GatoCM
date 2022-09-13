require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "GET /show" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin01", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should show you your own lists" do
        app = create(:application, user: user)
        list = create(:list, application: app)
        get "/#{user.username}/#{app.name}/lists/#{list.name_format}"
        expect(response).to have_http_status(200)
      end

      it "Should not show you other users lists" do
        app_2 = create(:application, name: "app_2", user: user_2)
        list_2 = create(:list, name: "list 2", application: app_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/lists/#{list_2.name_format}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see other user lists" do
        app_2 = create(:application, name: "app_2", user: user_2)
        list_2 = create(:list, name: "list 2", application: app_2)
        get "/#{user_2.username}/#{app_2.name}/lists/#{list_2.name_format}"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /new" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin01", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should show you new list form in your own app" do
        app = create(:application, user: user)
        get "/#{user.username}/#{app.name}/lists/new"
        expect(response).to have_http_status(200)
      end

      it "Should not show you list form in other users app" do
        app_2 = create(:application, name: "app_2", user: user_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/lists/new"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see list form in other user apps" do
        app_2 = create(:application, name: "app_2", user: user_2)
        get "/#{user_2.username}/#{app_2.name}/lists/new"
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

      it "Should allow you to create a list in your own app" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/lists/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          list:             { name: "Test" }
        }
        expect(response.status).to eq(302)
      end

      it "Should not allow you to create lists in other users apps" do
        @app = create(:application, user: user_2)
        expect do
          post "/#{user_2.username}/#{@app.name}/lists/",
          params: {
            application_name: @app.name,
            user_username:    user_2.username,
            list:             { name: "Test" }
          }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "Admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow admins to create lists in other users apps" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/lists/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          list:             { name: "Test" }
        }
        expect(response.status).to eq(302)        
      end
    end
  end

  describe "DELETE/ " do
    let(:user) { create(:user) }
    let(:user_1) { create(:user, username: "user_2", email: "user_2@me.com") }
    let(:admin) { create(:admin_user, username: "admin01", email: "admin@me.com") }


    context "Normal user" do

      before do
        sign_in(user)
      end

      it "Should allow you to delete a list in your own app" do
        @app = create(:application, user: user)
        @list = create(:list, application: @app)
        delete "/#{user.username}/#{@app.name}/lists/#{@list.name_format}"
        expect(response.status).to eq(302)    
      end

      it "Should allow to delete lists full of items" do
        @app = create(:application, user: user)
        @list = create(:list, application: @app)
        i = 1
        5.times do
          create(:item, content: "This is list #{i}", list: @list)
          i += 1
        end
        delete "/#{user.username}/#{@app.name}/lists/#{@list.name_format}"
        expect(response.status).to eq(302)    
      end

      it "Should not allow users to delete other's lists" do
        @app = create(:application, user: user_1)
        @list = create(:list, application: @app, name_format: 'holis')
        expect do
          delete "/#{user_1.username}/#{@app.name}/lists/#{@list.name_format}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "Admin user" do

      before do
        sign_in(admin)
      end

      it "Should allow admin users to delete user's lists" do
        @app = create(:application, user: user_1)
        @list = create(:list, application: @app)
        delete "/#{user_1.username}/#{@app.name}/lists/#{@list.name_format}"
        expect(response.status).to eq(302)
      end
    end
  end

  describe "POST /import_items" do
    let(:user) { create(:user) }
    let(:user_1) { create(:user, username: "user_2", email: "user_2@me.com") }
    let(:admin) { create(:admin_user, username: "admin01", email: "admin@me.com") }

    context "Normal user"do
      before do
        sign_in(user)
      end

      it "Should allow users to create items from an uploaded file" do
        @file = fixture_file_upload('sentences.json').tap do |file|
          file.content_type = 'application/json'
        end
        @app = create(:application, user: user)
        @list = create(:list, application: @app)
        post user_application_list_import_path(user_username: user.username,
                                               application_name: @app.name,
                                               list_name_format: @list.name_format,
                                               list: {uploaded_file: @file})
        expect(response.status).to eq(302)
      end


      it "Should not allow users to create items from a file different to JSON or YAML" do
        @file = fixture_file_upload('sentences.html')
        @app = create(:application, user: user)
        @list = create(:list, application: @app)
        post "/#{user.username}/#{@app.name}/lists/#{@list.name_format}/import", params: {"list" => {uploaded_file: @file}}
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("Something went wrong. Content type not supported")
      end
    end
  end

  describe "Serve items" do
    let(:user) { create(:user) }

    before do
      @app = create(:application, user: user)
      @list = create(:list, application: @app)
    end

    it "Should respond with a 200 to a succesfull request" do
      get "/#{@app.master_token.token}/#{user.username}/#{@app.name}/lists/#{@list.name_format}/serve.json"
      expect(response.status).to eq(200)
    end

    it "Should respond with an error to a request with wrong token" do
      random_token = SecureRandom.hex(12)
      expect {
        get "/#{random_token}//#{user.username}/#{@app.name}/lists/#{@list.name_format}/serve.json"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "Should respond with JSON format" do
      get "/#{@app.master_token.token}/#{user.username}/#{@app.name}/lists/#{@list.name_format}/serve.json"
      expect(response.header["Content-type"]).to eq("application/json; charset=utf-8")
    end
  end
end
