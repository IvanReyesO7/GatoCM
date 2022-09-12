require 'rails_helper'

RSpec.describe "AccountSettings", type: :request do
  
  describe "Change user information" do
    let (:user) { create(:user) }

    context "Normal users" do

      before do
        sign_in(user)
      end

      it "should allow users to change their username if not taken" do
        post "/#{user.username}/user_update/",
        params: {
          user: {username: "new_username"}
        }
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("Success!")
      end

      it "should allow users to change their email if not taken" do
        post "/#{user.username}/user_update/",
        params: {
          user: {email: "new_mail@email.com"}
        }
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("Success!")
      end

      it "shouldn't allow users to change their username if it has been taken" do
        @user_2 = create(:user, username: "user_2", email: "user_2@me.com") 
        post "/#{user.username}/user_update/",
        params: {
          user: {username: "user_2"}
        }
        expect(flash[:alert]).to eq("Sorry, something went wrong. Username has already been taken")
      end

      it "shouldn't allow users to change their username if it has been taken" do
        @user_3 = create(:user, username: "user_3", email: "user_3@me.com") 
        post "/#{user.username}/user_update/",
        params: {
          user: {email: "user_3@me.com"}
        }
        expect(flash[:alert]).to eq("Sorry, something went wrong. Email has already been taken")
      end
    end
  end
end