require 'rails_helper'
require 'faker'

describe Api::V1::ListsController, type: :request do
  describe 'GET /all' do
    let(:user){ create(:user) }
    let(:appuri){ create(:application, user: user) }
    let(:list){ create(:list,name_format: 'my_list', application: appuri) }
    let(:item){ create(:item, list: list) }
    i = 1
    15.times do
      let("item_#{i}".to_sym){ create(:item, content: Faker::Movies::StarWars.quote, list: list, name: "item_#{i}") }
      i +=  1
    end 

    it "Should retrieve all the lists of an App" do
      get "/api/v1/#{user.username}/#{appuri.name}/lists", params: {}, headers: {'Authorization' => "#{user.api_token}"}
      p response
      expect(response).to have_http_status(200)
    end

    it "Should return forbiden if no correct api token" do
      get "/api/v1/#{user.username}/#{appuri.name}/lists", params: {}, headers: {'Authorization' => "12345"}
      expect(response).to have_http_status(403)
    end

    it "Should be succesfull when retrieve all the items of an list with api token" do
      get "/api/v1/#{user.username}/#{appuri.name}/lists/#{list.name_format}", params: {}, headers: {'Authorization' => "#{user.api_token}"}
      expect(response).to have_http_status(200)
    end
  end
end