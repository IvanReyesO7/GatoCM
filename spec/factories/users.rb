FactoryBot.define do
  factory :user do
    email { "ivan@me.com" }
    password  { "password" }

    trait :no_password do
      password { nil }
    end

    factory :no_password_user, traits: [:no_password]
  end
end
