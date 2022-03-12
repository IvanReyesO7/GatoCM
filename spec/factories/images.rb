FactoryBot.define do
  factory :image do
    application { nil }
    title {"random title"}
    url { "https://example.com" }
    public_id { "kattongoukakyuunojutsu" }

    trait :no_title do
      title { nil }
    end

    trait :no_url do
      url { nil }
    end
  
    factory :no_title_image, traits: [:no_title]
    factory :no_url_image, traits: [:no_url]
  end
end
