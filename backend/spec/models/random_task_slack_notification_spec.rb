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
  end
end