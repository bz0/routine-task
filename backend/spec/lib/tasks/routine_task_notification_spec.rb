require 'rails_helper'
require 'rake'

describe 'rake task routine_task_notification_spec' do
  let(:task) { 'routine_task_notification:random' }

  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/routine_task_notification'
    Rake::Task.define_task(:environment)
    @rake[task].reenable
  end

  it 'is succeed.' do
    slack_incoming_webhook = SlackIncomingWebhook.new('test', ':sunglasses:')
    allow(slack_incoming_webhook).to receive(:exec).and_return("OK")
    expect(@rake[task].invoke).to be_truthy
  end
end
