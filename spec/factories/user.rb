FactoryBot.define do
  factory :user do
    sequence(:handle) { |n| "User#{n}" }
    password          { Faker::Internet.password(min_length: User::MIN_PASSWORD) }
    admin             { [true, false].sample }
    first_name        { %w(Mark Sandra John Pat Penny Rob).sample }
    last_name         { %w(Orr O'Neil McGonigle MacDonald Mcnab).sample }
  end
end
