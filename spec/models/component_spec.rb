require 'rails_helper'

RSpec.describe Component, type: :model do
  let (:application) do
    create(:application)
  end

  it "Should create a component after the creation of a new list" do
    list = create(:list, application: application)
    image = create(:image, application: application)
    code = create(:code, application: application)
    expect(application.components.count).to eq(3)
  end

  it "Should create the right component after a List creation" do
    list = create(:list, application: application)
    expect(application.components.first.real_component_type).to eq("List")
  end

  it "Should create the right component after a image creation" do
    image = create(:image, application: application)
    expect(application.components.first.real_component_type).to eq("Image")
  end

  it "Should create the right component after a piece of code creation" do
    code = create(:code, application: application)
    expect(application.components.first.real_component_type).to eq("Code")
  end

  it "Should point to an existing component" do
    list = create(:list, application: application)
    component = Component.find_by!(real_component_id: list.id)
    expect(list).to eq(List.find(component.real_component_id))
  end

  it "Should point to an existing method class" do
    image = create(:image, application: application)
    component = Component.find_by!(real_component_id: image.id)
    expect(component.real_component_type.constantize).to eq(image.class)
  end
end
