FactoryBot.define do
  factory :user do
    email { "ivan@me.com" }
    username { "ivan" }
    password  { "password" }
    api_token { "123456789abcdef" }
    admin { nil }

    trait :no_password do
      password { nil }
    end

    trait :no_api_token do
      api_token { nil }
    end

    trait :admin do
      admin { true }
    end

    factory :no_password_user, traits: [:no_password]
    factory :no_api_token_user, traits: [:no_api_token]
    factory :admin_user, traits: [:admin]
  end
end
