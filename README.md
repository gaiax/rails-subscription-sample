# README

## セットアップ

```sh
$ bundle install
$ rails db:create db:schema:load --trace

### Setup rubocop
$ git submodule update --init
```

## 開発用サーバーを起動する

```sh
$ gem install foreman
$ foreman start
```

