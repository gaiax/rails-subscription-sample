# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :user do
    email { 'taro@example.com' }
    password { 'password' }

    after(:build) do |instance|
      build(:stripe_user, user: instance) unless instance.stripe_user
    end
  end
end
