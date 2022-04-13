require 'rails_helper'
require 'rake'

describe 'rake task routine_task_notification_spec' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/routine_task_notification'
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task].reenable
  end

  describe 'routine_task_notification:random' do
    let(:task) { 'routine_task_notification:random' }
    it 'is succeed.' do
      expect(@rake[task].invoke).to be_truthy
    end
  end
end