# frozen_string_literal: true

# トップページ
class AuthController < ApplicationController
  def index; end

  def create
    # 最低限のデモアプリなので認証は未実装
    # ユーザーテーブルを用意するまでの暫定対応
    reset_session
    session['user_id'] = 1
    session['user_email'] = 'taro.subscription@example.com'
    session['user_name'] = 'サブスク太郎'
    stripe_user = StripeUser.find_by(user_id: session[:user_id])
    if stripe_user.present?
      stripe_user.update(
        customer_id: nil,
        is_subscribed: false,
        session_id: nil,
        subscription_id: nil
      )
    else
      StripeUser.create(user_id: session['user_id'])
    end

    redirect_to subscriptions_path
  end
end
