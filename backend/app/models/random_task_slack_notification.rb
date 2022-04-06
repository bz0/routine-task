class RandomTaskSlackNotification
  NOT_SET_ENV_KEY_MESSAGE = "SlackのWebhookURLが環境変数に設定されていません。.envをご確認下さい".freeze
  EXIST_TASK_MESSAGE      = "[Warn]タスクが存在しません。画面からタスクを追加して下さい".freeze

  USER_NAME = "通知Bot".freeze
  ICON_EMOJI = ":sunglasses:".freeze

  # タスク全件からランダムに１件Slackへ通知する
  def exec
    begin
      unless ENV.key?('SLACK_WEB_HOOK_URL')
        raise StandardError, NOT_SET_ENV_KEY_MESSAGE
      end

      task = random_task
      if task.nil?
        raise StandardError, EXIST_TASK_MESSAGE
      end

      message = "今日行うタスクは「#{task[:name]}」です！"
    rescue StandardError => e
      message = e.message
    end

    slack_incoming_webhook = SlackIncomingWebhook.new(USER_NAME, ICON_EMOJI)
    slack_incoming_webhook.exec(message)
  end

  # タスクからランダムに１件取得
  # @return [Task]
  def random_task
    Task.offset(rand(Task.count)).first
  end
end
