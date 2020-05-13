# README

## 環境

- Ruby 2.6
- MySQL 5.7
- Node.js 10

## セットアップ

あらかじめ Stripe のダッシュボードでプロジェクトを作成しておく。

[ダッシュボード – Stripe](https://dashboard.stripe.com/dashboard)

### 環境変数を設定する

`.env.example` をコピーし、テキストエディターで `.env` を編集して環境変数を設定する。

```
$ cp .env.example .env
```

#### STRIPE_PLAN_ID 定期支払い商品のID

1. [ダッシュボード – Stripe](https://dashboard.stripe.com/dashboard)のサイドメニューで `Billing`, `商品` と順にクリックする
2. `+ 新規` をクリックし、必須項目（ `任意` がついてない項目）を埋め、`料金プランを追加` ボタンをクリックして商品を作成する
3. 画面中央付近の `価格` に作成した商品があり、それをクリックする
4. 画面右上のIDをコピーする（ `plan_xxxxxxxxxxxxxx` ）
5. `.env` を開き、コピーしたIDを `STRIPE_PLAN_ID` にセットする

```
STRIPE_PLAN_ID=plan_xxxxxxxxxxxxxx
```

#### STRIPE_KEY_PUBLIC と STRIPE_KEY_SECRET

- `STRIPE_KEY_PUBLIC` JavaScriptが使うトークン
- `STRIPE_KEY_SECRET` Railsが使うトークン


1. [ダッシュボード – Stripe](https://dashboard.stripe.com/dashboard)のサイドメニューで `開発者`, `API キー` と順にクリックする
2. `公開可能キー` のトークンをコピーする（ `pk_test_xxxxxxxx` ）
3. `.env` を開き、コピーしたトークンを `STRIPE_KEY_PUBLIC` にセットする
4. `シークレットキー` 右の `テスト用キー` をクリックしてトークンを表示し、トークンをコピーする（ `sk_test_xxxxxxxx` ）
3. `.env` を開き、コピーしたトークンを `STRIPE_KEY_SECRET` にセットする

```
### トークンによって先頭の文字が違うので気をつける（ `pk` と `sk` ）
STRIPE_KEY_PUBLIC=pk_test_xxxxxxxx
STRIPE_KEY_SECRET=sk_test_xxxxxxxx
```

#### STRIPE_KEY_SECRET Railsで使うトークン



### アプリケーションをセットアップする

```sh
$ yarn install

### macOSの場合
$ bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib"

$ bundle install --path=vendor
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
