FactoryBot.define do
  factory :code do
    title { "Example code" }
    content { "<p>This is some random code</p>" }
    type { "html" }
    application { nil }

    trait :no_title do
      title { nil }
    end

    trait :no_content do
      content { nil }
    end

    factory :no_title_code, traits: [:no_title]
    factory :no_content_code, traits: [:no_content]
  end
end
