namespace :routine_task_notification do
    desc "タスクをランダムにslack通知する"
    task random_task_slack_notification: :environment do
        notifier = RandomTaskSlackNotification.new
        notifier.exec
    end
end
