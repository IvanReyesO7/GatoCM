require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:list) do
    create(:list)
  end

  it "Should not allow the creation of an item without content" do
    expect {
      create(:no_content_item, list: list)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Content Item cannot be blank")
  end
end
