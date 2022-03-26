require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  describe "POST /task 正常系" do
    it "[正常系]タスク正常登録" do
      post :create, params: {"name"=>"test"}
      expect(response).to have_http_status(200) # httpステータスが200かチェック
      expect(response.body).to include 'OK'     # レスポンスに「OK」が入っているかチェック
    end

    it "[異常系]リクエスト不正" do
      post :create, params: {}
      expect(response).to have_http_status(400) # httpステータスが400かチェック
      expect(response.body).to include 'NG'     # レスポンスに「NG」が入っているかチェック
    end
  end

=begin 
  # todo: saveの際に例外を発生させたいが上手くいかないので後でみる
  
  describe "POST /task/create [異常系]" do
    context 'DB登録失敗' do
      before do
        c = TasksController.new
        allow(c).to receive(:create).and_raise(ActiveRecord::RecordNotSaved, "error")
      end

      post :create, params: {"name"=>"test"}
      expect(response).to have_http_status(400) # httpステータスが400かチェック
      expect(response.body).to include 'NG'     # レスポンスに「NG」が入っているかチェック
    end
  end
=end

end
