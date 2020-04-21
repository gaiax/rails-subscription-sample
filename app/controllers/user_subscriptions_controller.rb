# frozen_string_literal: true

# ユーザー自身が購読状態を管理するコントローラー
class UserSubscriptionsController < ApplicationController
  def index
    @user_subscription = UserSubscription.new(
      subscribed: session[:subscribed] == true,
      # ユーザーテーブルを用意するまでの暫定対応
      user_id: 1
    )
  end

  def subscribe
    if session[:subscribed] == true
      redirect_to action: :index
      return
    end
    session[:subscribed] = true
    flash[:notice] = '購読しました'
    redirect_to action: :index
  end

  def unsubscribe
    if session[:subscribed] == false
      redirect_to action: :index
      return
    end
    session.delete(:subscribed)
    flash[:notice] = '購読を解除しました'
    redirect_to action: :index
  end

  private

  def params_edit
    params.permit(:subscribed)
  end
end
