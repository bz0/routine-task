 README

## ローカル環境構築手順

### 1.ローカル環境構築

下記コマンドを実行しDB作成・docker環境構築・railsサーバ立ち上げを行います。

```
$ cd backend && make build
```

下記URLで画面を開けます。

```
http://localhost:3001
```

- バックエンド(API)：http://localhost:3000
- フロントエンド：http://localhost:3001

### 2.slackへの通知設定

#### 2-1.slackのWebhookURLを取得する

Incoming Webhook インテグレーションの追加を行います。  
下記リンクに飛び、通知したいチャンネルを選択して下さい。  
https://slack.com/services/new/incoming-webhook

表示されたWebhookURLを.envに設定します。  

#### 2-2.環境設定ファイルのテンプレートをコピーする

```
$ cp .env.sample .env
```

#### 2-3.WebhookURLを.envに記載する

```.env
SLACK_WEB_HOOK_URL='WebhookURL'
```

#### 2-4.タスクのランダム通知

下記実行すると通知されます。  

```
$ docker-compose run backend rake routine_task_notification:random
```

※タスクが１件も登録されてない場合は「[Warn]タスクが存在しません。画面からタスクを追加して下さい」という通知が飛びます

### 備考

- .env.sampleにAPI_TOKENを直に貼ってます（実プロジェクトだとやらないですが、今回固定トークンな為そのまま貼ってます）
- 初期データとしてタスクが10件入ります