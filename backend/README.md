 README

## ローカル環境構築手順

下記コマンドを実行しDB作成・docker環境構築・railsサーバ立ち上げを行います。

```
$ cd backend && make build
```

- バックエンド：http://localhost:3000
- フロントエンド：http://localhost:3001

### slackのWebhookURLを設定

Incoming Webhook インテグレーションの追加を行います。  
下記リンクに飛び、通知したいチャンネルを選択して下さい。  
https://slack.com/services/new/incoming-webhook

出てきたWebhookURL(https://hooks.slack.com/services/xxxxx/xxxxx)を.envに設定して下さい

```
$ cp .env.sample .env
```

.env
```.env
SLACK_WEB_HOOK_URL='WebhookURL'
```

### タスクのランダム通知

下記実行すると通知されます。  

```
$ docker-compose run backend rake routine_task_notification:random
```

※タスクが１件も登録されてない場合は「[Warn]タスクが存在しません。画面からタスクを追加して下さい」という通知が飛びます


## テスト実行

```
$ docker-compose run backend rspec spec
```

## gem追加時の流れ

gemを追加する場合、Gemfileに記載の後下記を実行して下さい。

```
$ docker-compose down && docker-compose build --no-cache
```

## 考えていたこと

・Dockerをバックエンドとは別ディレクトリにしたかったが
　gemのmysql2がないといったエラーが起き解消できなかった為現在のディレクトリ構成になってます

・まず動くものを作りたい

・controller -> usecase -> domain -> repositoriesとレイヤ構造を作りたい
　ちょっとしたAPIなのでやる必要性は現状ないが今後の拡張性を考えて仕組みを作っておきたい

　今後を踏まえての実装にすべきか、今必要な分実装するかの判断基準が難しいですが
　
　・レイヤごとに役割を分ける（controller、activerecordの肥大化を防ぎたい）
　・実装をどこに書くか迷わないようにしたい（迷う場合は設計が間違っている可能性が高い）

　上記理由からアーキテクチャ導入して実装方針を決めたいと思いました。

・Railsのコーディング規約はどうなっているか、静的コード解析を行えるツールはあるか？

・moduleを利用するタイミングはライブラリ利用した場合等クラス名の競合が起きるかもしれないときの理解ですが
　必要になったらの判断は自分でやる必要があるので怖さはあります。そこを解消する実装方法があるか調べたいです
　(php(Laravelなどのフレームワーク)だと全てのファイルにnamespaceを割り当てる為競合が発生しづらい安心感がある）

・クラスのメソッドの引数や返り値に型は指定できるか？
　想定外の値が入ってきたときに例外でキャッチして早めに返したい
