# frozen_string_literal: true

# トップページ
class AuthController < ApplicationController
  def index; end

  def create
    # 最低限のデモアプリなので認証は未実装
    # データリセットのみを行う
    reset_session
    redirect_to user_subscriptions_path
  end
end
