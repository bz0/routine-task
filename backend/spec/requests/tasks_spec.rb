require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  describe "POST /task/create" do
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

    it "[異常系]DB登録失敗" do
      post :create, params: {"name"=>"test"}
      allow(Task).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved, "error")
      expect(response).to have_http_status(400) # httpステータスが400かチェック
      expect(response.body).to include 'NG'     # レスポンスに「NG」が入っているかチェック
    end
  end
end
