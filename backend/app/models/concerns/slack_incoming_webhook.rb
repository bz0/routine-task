class SlackIncomingWebhook
  def initialize(user_name, icon_emoji)
    @client = Slack::Notifier.new(
      ENV['SLACK_WEB_HOOK_URL'],
      username: user_name,
      icon_emoji: icon_emoji
    )
  end

  def exec(message)
    @client.ping message
  end
end
