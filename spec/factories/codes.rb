FactoryBot.define do
  factory :code do
    title { "Example code" }
    content { "<p>This is some random code</p>" }
    file_type { "html" }
    application { nil }

    trait :no_title do
      title { nil }
    end

    trait :no_content do
      content { nil }
    end

    trait :javascript do
      file_type { "javascript" }
      title { "test.js" }
      content { "let greetings = 'hello world';" }
    end

    factory :no_title_code, traits: [:no_title]
    factory :no_content_code, traits: [:no_content]
    factory :code_type_javascript, traits: [:javascript]
  end
end
