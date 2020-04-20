# frozen_string_literal: true

# ユーザーの継続課金状態を保持するモデル
class UserSubscription
  include ActiveModel::Model

  def initialize(subscribed:, user_id:)
    @subscribed = subscribed
    @user_id = user_id
  end

  def subscribed?
    @subscribed == true
  end
end
