# frozen_string_literal: true

# ユーザー自身が購読状態を管理するコントローラー
#
# クーポン利用やトライアル期間等、未実装の機能についてはドキュメント下部を参照
# https://stripe.com/docs/payments/checkout/subscriptions/starting
class SubscriptionsController < ApplicationController
  def index
    @subscribed = StripeUser.find_by(user_id: session['user_id']).subscribed?
  end

  def success
    stripe_user = StripeUser.find_by(
      session_id: success_params[:session_id]
    )
    unless stripe_user
      message = "不正なsession_id: #{success_params[:session_id]}"
      render json: { message: message }, status: :bad_request
      return
    end

    # エラーハンドリング
    # https://stripe.com/docs/api/errors/handling
    begin
      # https://stripe.com/docs/api/checkout/sessions/retrieve
      checkout_session = Stripe::Checkout::Session.retrieve(success_params[:session_id])
      stripe_user.update(
        # subscription_id: "sub_xxxxxxx..."
        subscription_id: checkout_session.subscription
      )
      redirect_to completed_subscriptions_path
    rescue Stripe::InvalidRequestError => e
      # 不正なsession_idを渡したときなど
      logger.error e.message
      logger.error e.backtrace.join("\n")
      @message = "不正なリクエスト: session_id=#{success_params[:session_id]}"
      render template: 'error', status: :bad_request
    rescue StandardError => e
      # 予期せぬエラーが発生したときなど
      logger.error e.message
      logger.error e.backtrace.join("\n")
      @message = "エラー: session_id=#{success_params[:session_id]}"
      render template: 'error', status: :bad_request
    end
  end

  def completed
    # 何もしない
  end

  def cancel
    redirect_to subscriptions_path
  end

  private

  def success_params
    params.permit(:session_id)
  end
end
