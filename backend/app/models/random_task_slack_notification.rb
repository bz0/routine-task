class RandomTaskSlackNotification
    NOT_SET_ENV_KEY_MESSAGE = "SlackのWebhookURLが環境変数に設定されていません。.envをご確認下さい"
    EXIST_TASK_MESSAGE      = "タスクが存在しません。画面からタスクを追加して下さい"

    # タスク全件からランダムに１件Slackへ通知する
    def exec
        puts Rails.logger.info "入った！！"
        begin
            unless ENV.key?('SLACK_WEB_HOOK_URL')
                raise StandardError, NOT_SET_ENV_KEY_MESSAGE
            end

            task = random_task
            puts task

            if task.nil?
                raise StandardError, EXIST_TASK_MESSAGE
            end

            message = "今日行うタスクは「#{task[:name]}」です！"
        rescue StandardError => e
            message = e.message
        end

        slack_notifier.ping message
    end
    
    # Slack通知設定
    def slack_notifier
        Slack::Notifier.new(ENV['SLACK_WEB_HOOK_URL'], username: '通知Bot', icon_emoji: ':sunglasses:')
    end

    # タスクからランダムに１件取得
    # @return [Task]
    def random_task
        puts Rails.logger.info Task.first.id
        puts Rails.logger.info Task.last.id
        return Task.where( 'id >= ?', rand(Task.first.id..Task.last.id) ).first
    end
end