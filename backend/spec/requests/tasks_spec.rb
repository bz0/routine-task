require 'rails_helper'

# describeには、テストの対象が何かを記述する。
# contextには、特定の条件が何かを記述する。
# exampleとitには、アウトプットが何かを記述する。日本語で記述するときはexample
# https://qiita.com/uchiko/items/d34c5d1298934252f58f

RSpec.describe TasksController, :type => :controller do
  describe "POST /task 登録処理" do
    context "nameパラメータに値をセット" do
      example "タスクを1件登録" do
        post :create, params: {"name"=>"test"}
        expect(response).to have_http_status(200)
        expect(response.body).to include 'OK'
      end
    end

    context "既にタスクが存在する" do
      before do
        create(:task, name: 'test')
      end

      example "タスク登録せずにエラー情報を返す" do
        post :create, params: {"name"=>"test"}
        expect(response).to have_http_status(500)
        expect(response.body).to include 'NG'
        expect(response.body).to include '既に登録されているタスクです'
      end
    end

    context "nameパラメータの値が空" do
      example "タスク登録せずにエラー情報を返す" do
        post :create, params: {"name" => ""}
        expect(response).to have_http_status(400)
        expect(response.body).to include 'NG'
      end
    end

    context "nameパラメータがない" do
      example "タスク登録せずにエラー情報を返す" do
        post :create, params: {}
        expect(response).to have_http_status(400)
        expect(response.body).to include 'NG'
      end
    end
  end

  describe "GET /task 全件取得" do
    context "5件データが存在する" do
      before do
        create_list(:task, 5)
      end

      example "5件分のタスク情報を返す" do
        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body, { :symbolize_names => true })
        tasks = json[:tasks]

        expect(json[:count]).to eq 5
        expect(tasks.length).to eq 5
        expect(response.body).to include 'OK'
      end
    end

    context "データが存在しない" do
      example "0件取得" do
        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body, { :symbolize_names => true })
        tasks = json[:tasks]

        expect(json[:count]).to eq 0
        expect(tasks.length).to eq 0
        expect(response.body).to include 'OK'
      end
    end
  end

  describe "POST /task 更新処理" do
    context "正常" do

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
