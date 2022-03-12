require 'rails_helper'

RSpec.describe "Images", type: :request do
  describe "GET /show" do

    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should show you your own images" do
        app = create(:application, user: user)
        image = create(:image, application: app)
        get "/#{user.username}/#{app.name}/images/#{image.name_format}"
        expect(response).to have_http_status(200)
      end

      it "Should not show you other users images" do
        app_2 = create(:application, name: "app_2", user: user_2)
        image_2 = create(:image, title: "image 2", application: app_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/images/#{image_2.name_format}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see other user images" do
        app_2 = create(:application, name: "app_2", user: user_2)
        image_2 = create(:image, title: "image 2", application: app_2)
        get "/#{user_2.username}/#{app_2.name}/images/#{image_2.name_format}"
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

      it "Should show you new image form in your own app" do
        app = create(:application, user: user)
        get "/#{user.username}/#{app.name}/images/new"
        expect(response).to have_http_status(200)
      end

      it "Should not show you image form in other users app" do
        app_2 = create(:application, name: "app_2", user: user_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/images/new"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see images form in other user apps" do
        app_2 = create(:application, name: "app_2", user: user_2)
        get "/#{user_2.username}/#{app_2.name}/images/new"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /create" do
    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }

    before do
      @file = fixture_file_upload('drake.jpeg').tap do |file|
        file.content_type = 'image/jpeg'
      end
    end

    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should allow you to create an image in your own app" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/images/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          image:             { title: "Test", photo: @file }
        }
        @image = Image.find_by!(application: @app, title: "Test")
        expect(@app.images.last).to eq(@image)
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("Success!")
        CloudinaryHelpers.clean(@image)
      end

      it "Should not allow you to create images in other users apps" do
        @app = create(:application, user: user_2)
        expect do
          post "/#{user_2.username}/#{@app.name}/images/",
          params: {
            application_name: @app.name,
            user_username:    user_2.username,
            image:             { title: "Test", photo: @file }
          }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "Should now allow you to upload a file type different to the supported types" do
        @file_two = fixture_file_upload('sentences.html').tap { |file| file.content_type = 'application/html' }
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/images/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          image:             { title: "Test", photo: @file_two }
        }
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("Something went wrong. Content type not supported")
      end

      it "should generate url and public id after create image" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/images/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          image:             { title: "Test", photo: @file }
        }
        @image = Image.find_by!(application: @app, title: "Test")
        expect(@app.images.last).to eq(@image)
        expect(@image.url).to be_truthy
        expect(@image.public_id).to be_truthy
        CloudinaryHelpers.clean(@image)
      end
    end

    context "Admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow admins to create images in other users apps" do
        @app = create(:application, user: user)
        post "/#{user.username}/#{@app.name}/images/",
        params: {
          application_name: @app.name,
          user_username:    user.username,
          image:             { title: "Test", photo: @file }
        }
        @image = Image.find_by!(application: @app, title: "Test")
        expect(@app.images.last).to eq(@image)
        expect(flash[:alert]).to eq("Success!")
        expect(response.status).to eq(302)
        CloudinaryHelpers.clean(@image)
      end
    end
  end

  describe "DELETE/ " do
    let(:user) { create(:user) }
    let(:user_1) { create(:user, username: "user_2", email: "user_2@me.com") }
    let(:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }


    context "Normal user" do

      before do
        sign_in(user)
      end

      it "Should allow you to delete an image in your own app" do
        @app = create(:application, user: user)
        @image = create(:image, application: @app)
        delete "/#{user.username}/#{@app.name}/images/#{@image.name_format}"
        expect(response.status).to eq(302)
      end

      it "Should not allow users to delete other's images" do
        @app = create(:application, user: user_1)
        @image = create(:image, application: @app, title: 'title')
        expect do
          delete "/#{user_1.username}/#{@app.name}/images/#{@image.name_format}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "Admin user" do

      before do
        sign_in(admin)
      end

      it "Should allow admin users to delete user's images" do
        @app = create(:application, user: user_1)
        @image = create(:image, application: @app)
        delete "/#{user_1.username}/#{@app.name}/images/#{@image.name_format}"
        expect(response.status).to eq(302)
      end
    end
  end
end
