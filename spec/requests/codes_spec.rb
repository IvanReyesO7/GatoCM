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

  describe "POST /create" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }

    before do
      @file = fixture_file_upload('sentences.html').tap do |file|
        file.content_type = 'text/html'
      end
    end

    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should allow you to create a piece of code in your own app" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/codes/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          code:             { file: @file }
        }
        @code = Code.find_by!(application: @app, title: @file.original_filename, file_type: 'html')
        expect(@app.codes.last).to eq(@code)
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("Success!")
      end

      it "Should not allow you to create a piece of code in other users apps" do
        @app = create(:application, user: user_2)
        expect do
          post "/#{user_2.username}/#{@app.name}/codes/",
          params: {
            application_name: @app.name,
            user_username:    user_2.username,
            code:             { file: @file }
          }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "Should now allow you to upload a file type different to the supported types" do
        @file_two = fixture_file_upload('drake.jpeg').tap { |file| file.content_type = 'image/jpeg' }
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/codes/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          code:             { file: @file_two }
        }
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("Something went wrong. File type not supported")
      end
    end

    context "Admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow admins to create a piece of code in other users apps" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/codes/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          code:             { file: @file }
        }
        @code = Code.find_by!(application: @app, title: @file.original_filename, file_type: 'html')
        expect(@app.codes.last).to eq(@code)
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("Success!")
      end
    end
  end
end
