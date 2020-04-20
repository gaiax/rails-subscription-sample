# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSubscription do
  let(:user_id) { 1 }
  context '#subscribed?' do
    it 'コンストラクタでtrueを渡すとtrueになる' do
      user_subscription = UserSubscription.new(
        subscribed: true,
        user_id: user_id
      )
      expect(user_subscription.subscribed?).to eq(true)
    end
    it 'コンストラクタでfalseを渡すとfalseになる' do
      user_subscription = UserSubscription.new(
        subscribed: false,
        user_id: user_id
      )
      expect(user_subscription.subscribed?).to eq(false)
    end
    it 'コンストラクタでnilを渡すとfalseになる' do
      user_subscription = UserSubscription.new(
        subscribed: nil,
        user_id: user_id
      )
      expect(user_subscription.subscribed?).to eq(false)
    end
  end
end
