# frozen_string_literal: true

# Stripe APIのユーザーデータを保持する（主にCustomer, Checkout）
# https://stripe.com/docs/payments/checkout
class StripeUser < ApplicationRecord
  belongs_to :user
  def subscribed?
    is_subscribed
  end
end
