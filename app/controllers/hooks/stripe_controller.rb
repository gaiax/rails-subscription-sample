# frozen_string_literal: true

require 'stripe'

class Hooks::StripeController < ApplicationController
  def protected_with_csrf_token
    false
  end

  # ここに飛んでくるイベントは30日間アクセス可能。
  # サポート対応やデバッグのためにIDの保持を検討するのも手か。
  # >NOTE: Right now, access to events through the Retrieve Event API is guaranteed only for 30 days.
  # https://stripe.com/docs/api/events
  def create
    # リクエストを検証する
    # https://stripe.com/docs/webhooks/signatures
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue JSON::ParserError => e
      # Invalid payload
      logger.error(e)
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      logger.error(e)
    end
    return render json: nil, status: :bad_request if event.blank?

    # `event` の型は `event.type` の前半（ドット以前）と同名のもの。
    # 例） `invoice.payment_succeeded` の場合、`event` の型は `Stripe::Invoice`
    logger.debug "event: #{event.class.name}"

    # Handle the event
    case event.type
    when 'invoice.payment_succeeded'
      invoice_payment_succeeded(event)
      render json: nil, status: :ok
    when 'invoice.payment_failed'
      invoice_payment_failed(event)
      render json: nil, status: :ok
    else
      # Unexpected event type
      render json: nil, status: :bad_request
    end
  end

  protected

  # いまの要件は *ユーザーが1人* なのでcustomer（StripeUser.customer_id）はチェックしない。
  # 理由はCLIツールの制約によるもの。回避策として `StripeUser.first` で代用する。
  #
  # 1. `$ stripe trigger` ではパラメーター（例：customer）を固定することができない
  # 2. `$ stripe fixtures` でパラメーターを固定できるが、データ構造が違うため、Webhook の代替にならない
  #
  # ダッシュボードでWebhookを登録してイベントを受け取る場合、`StripeUser.first` による回避策が不要になる。

  def invoice_payment_succeeded(_event)
    stripe_user = StripeUser.first
    stripe_user.is_subscribed = true
    stripe_user.save
  end

  # ここに到達した時点で定期課金の失敗は確定している
  # >When an automatic payment on a subscription fails, a charge.failed event and an invoice.payment_failed event are sent
  #
  # より複雑な状態管理を実装する場合はSubscriptionオブジェクトのstatusを利用する選択肢がある。
  # >and the subscription state becomes past_due. Stripe attempts to recover payment according to your configured retry rules.
  # https://stripe.com/docs/billing/subscriptions/overview#inactive
  #
  # Subscriptionオブジェクト
  # https://stripe.com/docs/api/subscriptions/object
  def invoice_payment_failed(_event) # Stripe::Invoice
    stripe_user = StripeUser.first
    stripe_user.is_subscribed = false
    stripe_user.save
    pp stripe_user
  end
end
