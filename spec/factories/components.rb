FactoryBot.define do
  factory :component do
    real_component_type { "MyString" }
    real_component_id { 1 }
    real_component_title { "MyString" }
    application { nil }
  end
end
