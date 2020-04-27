# README
bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib"

## 環境

- Ruby 2.6
- MySQL 5.7
- Node.js 10

## セットアップ

```sh
$ bundle install --path=vendor
$ yarn install
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

## 構成について

`session` で保持する値は本来テーブル（データベース）に保存するべき値です。

```sh
$ git grep session
```

