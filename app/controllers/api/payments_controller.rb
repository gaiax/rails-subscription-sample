# frozen_string_literal: true

require 'stripe'

class Api::PaymentsController < ApplicationController
  rescue_from StandardError, with: :handle_error

  # https://stripe.com/docs/billing/subscriptions/cards#test-integration
  def create
    Stripe::Subscription.create(
      customer: customer_id,
      items: [
        {
          plan: ENV['STRIPE_PLAN_ID']
        }
      ],
      expand: ['latest_invoice.payment_intent']
    )
    render json: { message: 'OK' }, status: :ok
  end

  def handle_error(e)
    message = case e
              when Stripe::InvalidRequestError, Stripe::AuthenticationError
                'エラーが発生しました。お手数ですが運営までお問い合わせください。'
              else
                'エラーが発生しました。しばらく時間を置いて再度お試しください。'
    end
    logger.error e.respond_to?(:json_body) ? e.json_body : e
    render json: { message: message }, status: :bad_request
  end

  # Stripeのカスタマー情報がない場合は作成する
  def customer_id
    # return session[:customer_id] if session[:customer_id]

    response = Stripe::Customer.create(
      payment_method: create_params[:payment_method_id],
      name: session['user_name'],
      email: session['user_email'],
      invoice_settings: {
        default_payment_method: create_params[:payment_method_id]
      },
    )
    session[:customer_id] = response.id
  end

  def create_params
    params.permit(:payment_method_id)
  end
end
