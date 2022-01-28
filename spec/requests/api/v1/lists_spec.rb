require 'rails_helper'
require 'faker'

describe Api::V1::ListsController, type: :request do
  describe 'GET /all' do
    let(:user){ create(:user) }
    let(:appuri){ create(:application, user: user) }
    let(:list){ create(:list, application: appuri) }
    i = 1
    15.times do
      let("item_#{i}".to_sym){ create(:item, content: Faker::Movies::StarWars.quote, list: list) }
      i +=  1
    end

    it "Should retrieve all the items of a list" do
      get "/api/v1/#{user.username}/#{appuri.name}/lists", params: {}, headers: {'Authorization' => "#{user.api_token}"}
      expect(response).to have_http_status(200)
    end

    it "Should return forbiden if no correct api token" do
      get "/api/v1/#{user.username}/#{appuri.name}/lists", params: {}, headers: {'Authorization' => "12345"}
      expect(response).to have_http_status(403)
    end

  end
end