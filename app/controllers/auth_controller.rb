# frozen_string_literal: true

# トップページ
class AuthController < ApplicationController
  def index; end

  def create
    # 最低限のデモアプリなので認証は未実装
    reset_session
    session['user_email'] = 'taro.subscription@example.com'
    session['user_name'] = 'サブスク太郎'
    redirect_to user_subscriptions_path
  end
end
