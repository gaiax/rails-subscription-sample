# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :stripe_user do
    is_subscribed { true }

    association :user, factory: :user, strategy: :build
    after(:build) do |instance|
      instance.user&.stripe_user = instance
    end
  end
end
