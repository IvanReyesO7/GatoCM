require 'rails_helper'

RSpec.describe Image, type: :model do

  let (:application) do
    create(:application)
  end

  it "Should not allow to create an image without title" do
    expect {
      image_1 = create(:no_title_image, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Title can't be blank")
  end

  it "Should not allow to create an image without url" do
    expect {
      image_1 = create(:no_url_image, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Url can't be blank")
  end

  it "Should not allow to create an image with a taken name in the same app" do
    image_1 = create(:image, application: application)
    expect {
      image_2 = create(:image, application: application)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Title You already have an image in this app with that title.")
  end
end
