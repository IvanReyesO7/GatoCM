require 'rails_helper'

RSpec.describe Application, type: :model do

  let (:user) do
    create(:user)
  end

  it "Should not allow to create another app with the same name" do
    app_1 = create(:application, user: user, name: "My application")
    expect {
      app_2 = create(:application, user: user, name: "My application")
    }.to raise_error(ActiveRecord::RecordInvalid,"Validation failed: Name You already have an app with that name.")
  end
end
