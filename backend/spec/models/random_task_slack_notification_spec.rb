require 'rails_helper'

RSpec.describe RandomTaskSlackNotification do
  describe 'slack通知のテスト' do
    context 'ランダム(seedを指定する為返り値は固定(rspec spec --seed 1))' do
      before do
        create(:task, name: 'test1')
        create(:task, name: 'test2')
        create(:task, name: 'test3')
      end

      example 'rspec spec --seed 1で実行すると「test2」が返ってくる' do
        subject = described_class.new
        expect(subject.random_task.name).to eq "test2"
      end
    end

    context '#exec' do
      example 'slack通知が成功すると「OK」が返る' do
        random_task_slack_notification = described_class.new
        allow(random_task_slack_notification).to receive(:exec).and_return("OK")
        expect(random_task_slack_notification.exec).to eq "OK"
      end

      example 'slack通知が失敗すると「NG」が返る' do
        random_task_slack_notification = described_class.new
        allow(random_task_slack_notification).to receive(:exec).and_return("NG")
        expect(random_task_slack_notification.exec).to eq "NG"
      end
    end
  end
end
