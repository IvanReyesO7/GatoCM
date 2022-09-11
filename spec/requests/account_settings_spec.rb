require 'rails_helper'

RSpec.describe "AccountSettings", type: :request do
  let (:user) do
    create(:user)
  end

  let(:user_2) do
    create(:user, username: "user_2", email: "user_2@me.com")
  end

  let(:admin) do
    create(:admin_user, username: "admin", email: "admin@me.com")
  end

  context "Normal users" do

    before do
      sign_in(user)
    end
  
    describe "Change user information" do
      it "should allow users to change their username" do
        post "/#{user.username}/user_update/",
        params: {
          user: {username: "new_username"}
        }
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("Success!")
      end
    end
  end
end