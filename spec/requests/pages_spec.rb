require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "describe GET /" do
    context "Logged in user" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "should redirect to dashboard view" do
        get "/"

        expect(response).to redirect_to("/#{user.username}")
        expect(response.status).to eq(302)
      end
    end
    context "No session user" do
      it "should go to /" do
        get "/"

        expect(response.status).to eq(200)
      end
    end
  end
end