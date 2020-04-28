# frozen_string_literal: true

# Stripe APIのユーザーデータを保持する（主にCustomer, Checkout）
# https://stripe.com/docs/payments/checkout
class StripeUser < ApplicationRecord
  def subscribed?
    subscription_id.present?
  end
end
