# README

## 環境

- Ruby 2.6
- MySQL 5.7
- Node.js 10

## セットアップ

```sh
$ yarn install

### macOSの場合
$ bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib"

$ bundle install --path=vendor
$ cp .env.example .env
$ rails db:create db:schema:load --trace

### MySQLを起動する
$ docker-compose up -d

### rubocopのルールをダウンロード
$ git submodule update --init
```

## 開発用サーバーを起動する

```sh
$ gem install foreman
$ foreman start
```

## アプリケーションを試す

### ブラウザで操作する

http://localhost:3000/ にアクセスし、UIが示す操作を行う。


### 定期支払いのWebhookをエミュレートする

Stripe公式のコマンドラインツールをインストールする。

- [Using the Stripe CLI | Stripe](https://stripe.com/docs/stripe-cli)

`stripe trigger` でイベントを送信するため、事前に `stripe listen` を実行する。

```sh
$ stripe listen --forward-to localhost:3000/hooks/stripe
```

出力されるキー（ `whsec_xxxxxxxx` ）を環境変数 `STRIPE_WEBHOOK_SECRET` にセットする。

その後、 `stripe trigger` でイベントをローカルのサーバーに送信する。

```sh
### 定期支払いに成功したときのイベントを送信する
$ stripe trigger invoice.payment_succeeded

### 定期支払いに失敗したときのイベント
$ stripe trigger invoice.payment_failed
```

## 構成について

`session` で保持する値は本来テーブル（データベース）に保存するべき値。

```sh
$ git grep session
```

## トラブルシューティング

### `stripe trigger` でイベントが飛ばない

いくつかの可能性がある。

- `stripe listen --forward-to $WEBHOOK_URL` を起動していない
- 数分遅れてイベントが飛ぶ場合がある

## リソース

- [ダッシュボード - Stripe](https://dashboard.stripe.com/)
- [Documentation | Stripe](https://stripe.com/docs)
- [Checkout overview | Stripe Checkout](https://stripe.com/docs/payments/checkout)
- [Subscription lifecycle and events | Stripe Billing](https://stripe.com/docs/billing/subscriptions/overview#settings)
- [Using the Stripe CLI | Stripe](https://stripe.com/docs/stripe-cli)
- [Stripe定期課金のライフサイクル - Innovator Japan Engineers’ Blog](https://tech.innovator.jp.net/entry/stripe-subscription-billing-lifecycle-event)
