FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "!password" }
    password_confirmation { "!password" }
    role { 0 }

    trait :admin do
      role { 2 }
    end

    trait :other_user do
      sequence(:name) { |n| "Other User #{n}" }
      sequence(:email) { |n| "otheruser#{n}@example.com" }
    end
  end
end
