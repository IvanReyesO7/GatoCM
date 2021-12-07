FactoryBot.define do
  factory :user do
    email { "ivan@me.com" }
    password  { "password" }
    api_token { "123456789abcdef" }

    trait :no_password do
      password { nil }
    end

    trait :no_api_token do
      api_token { nil }
    end

    factory :no_password_user, traits: [:no_password]
    factory :no_api_token_user, traits: [:no_api_token]
  end
end
