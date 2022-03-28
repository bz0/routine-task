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

    context "既に同じタスク名が存在する" do
      before do
        create(:task, name: 'test')
      end

      example "タスク登録せずにエラー情報を返す" do
        post :create, params: {"name"=>"test"}
        expect(response).to have_http_status(500)
      
        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:status]).to eq 'NG'
        expect(json[:message]).to eq TasksController::ALREADY_REGISTERED_TASK_MESSAGE
      end
    end

    context "nameパラメータの値が空" do
      example "タスク登録せずにメッセージを返す" do
        post :create, params: {"name" => ""}
        expect(response).to have_http_status(400)
        expect(response.body).to include 'NG'

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:message]).to eq TasksController::BAD_REQUEST_MESSAGE
      end
    end

    context "nameパラメータがない" do
      example "タスク登録せずにエラー情報を返す" do
        post :create, params: {}
        expect(response).to have_http_status(400)
        expect(response.body).to include 'NG'

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:message]).to eq TasksController::BAD_REQUEST_MESSAGE
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
        data = json[:data]

        expect(json[:count]).to eq 5
        expect(data.length).to eq 5
        expect(response.body).to include 'OK'
      end
    end

    context "データが存在しない" do
      example "0件分のタスク情報を返す" do
        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body, { :symbolize_names => true })
        data = json[:data]

        expect(json[:count]).to eq 0
        expect(data.length).to eq 0
        expect(response.body).to include 'OK'

      end
    end
  end

  # 同じものを使いまわしする為定数指定
  BEFORE_UPDATE_TASK_NAME = '皿洗いする' # 更新前のタスク名
  AFTER_UPDATE_TASK_NAME = '掃除する'    # 更新後のタスク名

  describe "POST /task 更新処理" do
    context "更新対象のタスクが存在する" do
      before do
        create(:task, name: BEFORE_UPDATE_TASK_NAME)
      end

      example "タスク名が「掃除する」に更新される" do
        task = Task.find_by(name: BEFORE_UPDATE_TASK_NAME)
        post :update, params: {"id" => task[:id], "name" => AFTER_UPDATE_TASK_NAME}
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        after_name = json[:data][:name]
        expect(after_name).to eq AFTER_UPDATE_TASK_NAME
      end
    end

    context "更新対象のタスクが存在しない" do
      example "更新されずエラー情報が返る" do
        post :update, params: {"id" => 100, "name" => AFTER_UPDATE_TASK_NAME}
        expect(response).to have_http_status(500)

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:message]).to eq TasksController::UPDATE_TASK_EXIST_MESSAGE
      end
    end
  end

=begin 
  # todo: saveの際に例外を発生させたいが上手くいかないので後でみる

  describe "POST /task/create [異常系]" do
    context 'DB登録失敗' do
      before do
        c = dataController.new
        allow(c).to receive(:create).and_raise(ActiveRecord::RecordNotSaved, "error")
      end

      post :create, params: {"name"=>"test"}
      expect(response).to have_http_status(400) # httpステータスが400かチェック
      expect(response.body).to include 'NG'     # レスポンスに「NG」が入っているかチェック
    end
  end
=end

end
