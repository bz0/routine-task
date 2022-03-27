require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  describe "POST /task 登録処理" do
    context "正常" do
      it "タスク登録" do
        post :create, params: {"name"=>"test"}
        expect(response).to have_http_status(200) # httpステータスが200かチェック
        expect(response.body).to include 'OK'     # レスポンスに「OK」が入っているかチェック
      end
    end

    context "異常" do
      it "nameの値が空" do
        post :create, params: {"name" => ""}
        expect(response).to have_http_status(400) # httpステータスが400かチェック
        expect(response.body).to include 'NG'     # レスポンスに「NG」が入っているかチェック
      end

      it "nameなし" do
        post :create, params: {}
        expect(response).to have_http_status(400) # httpステータスが400かチェック
        expect(response.body).to include 'NG'     # レスポンスに「NG」が入っているかチェック
      end
    end
  end

  describe "GET /task 全件取得" do
    context "正常" do
      before do
        create_list(:task, 5)
      end

      it "5件取得" do
        get :index
        expect(response).to have_http_status(200) # httpステータスが200かチェック
        json = JSON.parse(response.body, { :symbolize_names => true })
        tasks = json[:tasks]

        expect(json[:count]).to eq 5 # 件数が5かチェック
        expect(tasks.length).to eq 5 # タスクが5件分入っているかチェック
        expect(response.body).to include 'OK' # レスポンスに「OK」が入っているかチェック
      end
    end

    context "データなし" do
      it "0件取得" do
        get :index
        expect(response).to have_http_status(200) # httpステータスが200かチェック
        json = JSON.parse(response.body, { :symbolize_names => true })
        tasks = json[:tasks]

        expect(json[:count]).to eq 0 # 0件かチェック
        expect(tasks.length).to eq 0 # タスクが0件分入っているかチェック
        expect(response.body).to include 'OK' # レスポンスに「OK」が入っているかチェック
      end
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
