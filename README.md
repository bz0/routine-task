 README

## ローカル環境構築手順

下記コマンドを実行しDB作成・docker環境構築・railsサーバ立ち上げを行います。

```
$ cd backend && make build && make up
```

下記URLで画面を開けます。

```
http://localhost:3001
```

- バックエンド：http://localhost:3000
- フロントエンド：http://localhost:3001

### slackのWebhookURLを設定

Incoming Webhook インテグレーションの追加を行います。  
下記リンクに飛び、通知したいチャンネルを選択して下さい。  
https://slack.com/services/new/incoming-webhook

出てきたWebhookURL（https://hooks.slack.com/services/xxxxx/xxxxx）を.envに設定して下さい

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