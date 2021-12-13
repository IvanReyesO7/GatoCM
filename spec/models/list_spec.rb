require 'rails_helper'

RSpec.describe List, type: :model do 
  it "Should not allow to create a list with a taken name in the same app" do
    app = create(:application)
    list_1 = create(:list, application: app)
    expect {
      list_2 = create(:list, application: app)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name You already have a list in this app with that name.")
  end
end
