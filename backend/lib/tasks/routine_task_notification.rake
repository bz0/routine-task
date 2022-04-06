namespace :routine_task_notification do
  desc "タスクをランダムにslack通知する"
  task random: :environment do
    notifier = RandomTaskSlackNotification.new
    notifier.exec
  end
end
