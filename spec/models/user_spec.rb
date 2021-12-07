require 'rails_helper'

RSpec.describe User, type: :model do
  it "Should have a password" do
    expect { 
      user = create(:no_password_user, email: 'example@me.com')
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password can't be blank")
  end

  it "Should have an api token" do
    expect {
      user = create(:no_api_token_user, email: 'example@me.com')
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Api token can't be blank")
  end

end
