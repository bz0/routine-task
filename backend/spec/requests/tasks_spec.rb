require 'rails_helper'

# describeには、テストの対象が何かを記述する。
# contextには、特定の条件が何かを記述する。
# exampleとitには、アウトプットが何かを記述する。日本語で記述するときはexample
# https://qiita.com/uchiko/items/d34c5d1298934252f58f

RSpec.describe "Tasks", type: :request do
  let :headers do
    { Authorization: "Bearer #{ENV['API_TOKEN']}" }
  end

  describe "POST /tasks 登録処理" do
    context "nameパラメータに値をセット" do
      example "タスクを1件登録" do
        post tasks_path, params: { "name" => "test" }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)
        json = JSON.parse(response.body, { :symbolize_names => true })

        expect(json[:status]).to eq TasksController::STATUS_SUCCESS

        # 登録したデータが返ってきているか
        expect(json[:data][:name]).to eq 'test'
        expect(json[:data][:deleted_at]).to eq nil
      end
    end

    context "既に同じタスク名が存在する" do
      before do
        create(:task, name: 'test')
      end

      example "タスク登録せずにエラー情報を返す" do
        post tasks_path, params: { "name" => "test" }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:status]).to eq TasksController::STATUS_ERROR
        expect(json[:error][:message]).to eq TasksController::ALREADY_REGISTERED_TASK_MESSAGE
      end
    end

    context "論理削除されているが既に同じタスク名が存在する" do
      before do
        create(:task, name: 'test', deleted_at: Time.now)
      end

      example "タスクを1件登録" do
        post tasks_path, params: { "name" => "test" }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)
        json = JSON.parse(response.body, { :symbolize_names => true })

        expect(json[:status]).to eq TasksController::STATUS_SUCCESS

        # 登録したデータが返ってきているか
        expect(json[:data][:name]).to eq 'test'
        expect(json[:data][:deleted_at]).to eq nil
      end
    end

    context "nameパラメータの値が空" do
      example "タスク登録せずにメッセージを返す" do
        post tasks_path, params: { "name" => "" }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:status]).to eq TasksController::STATUS_ERROR
        expect(json[:error][:message]).to eq TasksController::BAD_REQUEST_MESSAGE
      end
    end

    context "nameパラメータがない" do
      example "タスク登録せずにエラー情報を返す" do
        post tasks_path, params: {}, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:status]).to eq TasksController::STATUS_ERROR
        expect(json[:error][:message]).to eq TasksController::BAD_REQUEST_MESSAGE
      end
    end

    context "DB登録を失敗させる" do
      it "タスク登録せずにエラー情報を返す" do
        allow_any_instance_of(Task).to receive(:save!).and_return(false)

        post tasks_path, params: { "name" => "test" }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:status]).to eq TasksController::STATUS_ERROR
        expect(json[:error][:message]).to eq TasksController::FAILED_REGISTER_TASK_MESSAGE
      end
    end
  end

  describe "GET /tasks 全件取得" do
    context "5件データが存在する" do
      before do
        create_list(:task, 5)
      end

      example "5件分のタスク情報を返す" do
        get tasks_path, params: {}, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)
        json = JSON.parse(response.body, { :symbolize_names => true })
        data = json[:data]

        expect(json[:count]).to eq 5
        expect(data.length).to eq 5
        expect(json[:status]).to eq TasksController::STATUS_SUCCESS
      end
    end

    context "データが存在しない" do
      example "0件分のタスク情報を返す" do
        get tasks_path, params: {}, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        data = json[:data]

        expect(json[:count]).to eq 0
        expect(data.length).to eq 0
        expect(json[:status]).to eq TasksController::STATUS_SUCCESS
      end
    end

    context "検索ワードに「掃除」を指定" do
      before do
        create(:task, name: "台所の掃除")
        create(:task, name: "掃除用品の補充")
        create(:task, name: "玄関の掃除する")
        create(:task, name: "洗濯")
        create(:task, name: "不要品の整理")
      end

      example "タスク名に「掃除」が入っているタスク情報を返す" do
        get tasks_path, params: { keyword: "掃除" }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)
        json = JSON.parse(response.body, { :symbolize_names => true })
        data = json[:data]

        expect(json[:count]).to eq 3
        expect(data.length).to eq 3
        expect(json[:status]).to eq TasksController::STATUS_SUCCESS
      end
    end
  end

  describe "PATCH /tasks 更新処理" do
    let(:before_update_task) { '皿洗いする' }
    let(:after_update_task) { '掃除する' }

    context "更新対象のタスクが存在する" do
      before do
        create(:task, name: before_update_task)
      end

      example "タスク名が「掃除する」に更新される" do
        task = Task.find_by(name: before_update_task)
        patch task_path(task), params: { id: task[:id], name: after_update_task }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        after_name = json[:data][:name]

        expect(json[:status]).to eq TasksController::STATUS_SUCCESS
        expect(after_name).to eq after_update_task
      end
    end

    context "更新対象のタスクが存在しない" do
      example "更新されずエラー情報が返る" do
        patch task_path(100), params: { id: 100, name: after_update_task }, headers: headers
        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })

        expect(json[:status]).to eq TasksController::STATUS_ERROR
        expect(json[:error][:message]).to eq TasksController::TASK_EXIST_MESSAGE
      end
    end

    context "DB登録を失敗させる" do
      before do
        create(:task, name: before_update_task)
      end

      example "更新されずエラー情報が返る" do
        task = Task.find_by(name: before_update_task)
        allow_any_instance_of(Task).to receive(:save!).and_return(false)
        patch task_path(task), params: { id: task[:id], name: after_update_task }, headers: headers

        expect(response).to have_http_status(TasksController::HTTP_STATUS_200)

        json = JSON.parse(response.body, { :symbolize_names => true })
        expect(json[:status]).to eq TasksController::STATUS_ERROR
        expect(json[:error][:message]).to eq TasksController::FAILED_UPDATE_TASK_MESSAGE
      end
    end
  end
end
