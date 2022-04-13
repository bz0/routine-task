class SlackIncomingWebhook
  STATUS_SUCCESS = "OK".freeze
  STATUS_ERROR = "NG".freeze

  def initialize(user_name, icon_emoji)
    @client = Slack::Notifier.new(
      ENV['SLACK_WEB_HOOK_URL'],
      username: user_name,
      icon_emoji: icon_emoji
    )
  end

  def exec(message)
    begin
      @client.ping message
      status = STATUS_SUCCESS
    rescue Slack::Notifier::APIError => e
      status = STATUS_ERROR
    end

    status
  end
end
