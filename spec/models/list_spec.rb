require 'rails_helper'

RSpec.describe List, type: :model do
  let (:application) do
    create(:application)
  end
  it "Should not allow to create a list with a taken name in the same app" do
    list_1 = create(:list, application: application)
    expect {
      list_2 = create(:list, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name You already have a list in this app with that name.")
  end

  it "Should generate name formate before creation" do
    new_list = create(:list, name:"New List For My New App")
    expect(new_list.name_format).to eq("new_list_for_my_new_app")
  end
end
