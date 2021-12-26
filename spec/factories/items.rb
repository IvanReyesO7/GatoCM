FactoryBot.define do
  factory :item do
    name { "MyString" }
    content { "MyText" }
    list { nil }

    trait :no_content do
      content { nil }
    end

    factory :no_content_item, traits: [:no_content]
  end
end
