require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  describe "POST /task/create" do
    it "タスク正常登録" do
      post :create, params: {"name"=>"test"}
      expect(response).to have_http_status(200) # httpステータスが200かチェック
      expect(response.body).to include 'OK'     # レスポンスに「OK」が入っているかチェック
    end
  end
end
