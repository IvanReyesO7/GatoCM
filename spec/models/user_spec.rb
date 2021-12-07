require 'rails_helper'

RSpec.describe User, type: :model do
  it "Should be invalid without a password" do
    expect { 
      user = create(:no_password_user, email: 'example@me.com')
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password can't be blank")
  end

  it "Should create an api token after creation" do
    user = create(:no_api_token_user, email: 'example@me.com')
    expect(user.api_token).not_to be_nil
  end
end
