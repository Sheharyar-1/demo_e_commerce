FactoryBot.define do
  factory :order do
    association :user
    subtotal { 100.0 }
    status { 'in_progress' }

    trait :placed do
      status {'placed'}
    end
    trait :other_order do
      association :user, factory: :user, traits: [:other_user]
      subtotal { 200.0 }
    end
  end
end
