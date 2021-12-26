require 'rails_helper'

RSpec.describe Code, type: :model do

  let (:application) do
    create(:application)
  end

  it "Should not allow to create a piece od code without a title" do
    expect {
      create(:no_title_code, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Title can't be blank")
  end

  it "Should not allow to create a piece of code without content" do
    expect {
      create(:no_content_code, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Content can't be blank")
  end

  it "Should not allow to create a piece of code with a taken item in the same app" do
    code_1 = create(:code, application: application)
    expect {
      code_2 = create(:code, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Title You already have a piece of code in this app with that title.")
  end

  it "Should generate name formate before creation" do
    new_code = create(:code, title:"New Code For My New App", application: application)
    expect(new_code.name_format).to eq("new_code_for_my_new_app")
  end
end
