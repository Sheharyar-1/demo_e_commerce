FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "This is a sample product description." }
    price { 10 }
    total_quantity { 50 }
    stock { 50 }
  end
end
