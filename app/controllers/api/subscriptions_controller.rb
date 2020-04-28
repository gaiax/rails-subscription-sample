# frozen_string_literal: true

require 'stripe'

class Api::SubscriptionsController < ApplicationController

  def subscribe
    base_url = "#{request.scheme}://#{request.host}:#{request.port}"
    # `session` は 既に ApplicationController が定義しているため、
    # 変数名は2単語にする
    checkout_session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      subscription_data: {
        items: [{
          # Stripeのダッシュボードでプランを作成する
          # https://dashboard.stripe.com/test/subscriptions/products
          plan: ENV['STRIPE_PLAN_ID']
        }]
      },
      customer: customer_id,
      # >Make the Session ID available on your success page by including the {CHECKOUT_SESSION_ID} template variable in the success_url as in the above example.
      # >Don’t rely on the redirect to the success_url alone for fulfilling purchases, as:
      # > - Malicious users could directly access the success_url without paying and gain access to your goods or services.
      # > - Customers may not always reach the success_url after a successful payment. It is possible they close their browser tab before the redirect occurs.
      # https://stripe.com/docs/payments/checkout/subscriptions/starting
      success_url: "#{base_url}#{success_subscriptions_path}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{base_url}#{cancel_subscriptions_path}"
    )
    # あとでStripeからコールバックしたときにsession_idを検証する
    StripeUser.find_by(user_id: session[:user_id]).update(
      # customer_id: "cus_xxxxxxxxxx..."
      customer_id: customer_id,
      # session_id: "cs_xxxx_xxxxxx..."
      session_id: checkout_session.id
    )
    render json: { session_id: checkout_session.id }, status: :created
  end

  def unsubscribe
    stripe_user = StripeUser.find_by(user_id: session[:user_id])
    return render json: nil, status: :ok unless stripe_user.subscribed?

    # エラーハンドリング
    # https://stripe.com/docs/api/errors/handling
    begin
      # https://stripe.com/docs/api/subscriptions/cancel
      subscription = Stripe::Subscription.delete(stripe_user.subscription_id)
      if subscription.canceled_at > 0
        stripe_user.update(
          subscription_id: nil
        )
        render json: nil, status: :ok
      else
        # 予期せぬエラーが発生したときなど
        logger.error "予期せぬエラー: subscription_id=#{stripe_user.subscription_id}"
        render json: { message: 'エラー' }, status: 500
      end
    rescue Stripe::InvalidRequestError => e
      # 購読解除済みのsubscription_idを指定したときなど
      logger.error e.message
      logger.error e.backtrace.join("\n")
      render json: { message: '不正なリクエスト' }, status: :bad_request
    rescue StandardError => e
      # 予期せぬエラーが発生したときなど
      logger.error e.message
      logger.error e.backtrace.join("\n")
      message = "エラー: session_id=#{success_params[:session_id]}"
      render json: { message: message }, status: :bad_request
    end
  end

  private

  # Stripeのカスタマー情報がない場合は作成する
  def customer_id
    return session[:customer_id] if session[:customer_id]

    response = Stripe::Customer.create(
      payment_method: create_params[:payment_method_id],
      name: session['user_name'],
      email: session['user_email'],
      invoice_settings: {
        default_payment_method: create_params[:payment_method_id]
      }
    )
    session[:customer_id] = response.id
  end

  def create_params
    params.permit(:payment_method_id)
  end
end
