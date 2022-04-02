class TasksController < ApplicationController
    STATUS_SUCCESS = "OK"
    STATUS_ERROR   = "NG"
    HTTP_STATUS_200 = 200
    
    TASK_EXIST_MESSAGE       = "対象のタスクが見つかりません"
    FAILED_UPDATE_TASK_MESSAGE      = "タスクの更新に失敗しました"
    BAD_REQUEST_MESSAGE             = "リクエストが不正です"
    FAILED_REGISTER_TASK_MESSAGE    = "タスクの登録に失敗しました"
    ALREADY_REGISTERED_TASK_MESSAGE = "既に登録されているタスクです"

    def index
        begin
            tasks = Task.enabled.order(updated_at: "DESC") # todo:全件取得しているが後でページネーションにしたい
            json = { status: STATUS_SUCCESS, count: tasks.count, data: tasks }
        rescue StandardError => e
            json = { status: STATUS_ERROR, error:{message:e.message} }
        end

        render status: 200, json: json
    end

    # 条件分岐が複雑になり分かりづらくなりそうなので
    # 例外でキャッチするようにしています

    def create
        begin
            params.require(:name)

            # 既に登録されているタスクかチェックする
            task = Task.find_by(name: params[:name])
            unless task.nil?
                raise StandardError, ALREADY_REGISTERED_TASK_MESSAGE
            end

            task = Task.new
            task.name = params[:name]
            
            unless task.save!
                raise StandardError, FAILED_REGISTER_TASK_MESSAGE
            end
            
            json = {status:STATUS_SUCCESS, data: task }
        rescue ActionController::ParameterMissing => e
            # 未入力の場合
            json = {status:STATUS_ERROR, error: {message: BAD_REQUEST_MESSAGE}}
        rescue StandardError => e
            # DB登録に失敗した場合
            json = {status:STATUS_ERROR, error: {message: e.message}}
        end

        # todo:パラメータが不正な場合にエラーを返せるようにしたい
        render status: HTTP_STATUS_200, json: json
    end

    def update
        begin
            params.require(:id)
            params.require(:name)
            task = Task.find_by(id: params[:id])

            if task.nil? # レコードが存在するかチェックする
                raise StandardError, TASK_EXIST_MESSAGE
            end

            task.name = params[:name]
            
            unless task.save!
                raise StandardError, FAILED_UPDATE_TASK_MESSAGE
            end
            
            json = {status:STATUS_SUCCESS, data:task}
        rescue ActionController::ParameterMissing => e
            # 未入力の場合
            json = {status:STATUS_ERROR, error: {message: BAD_REQUEST_MESSAGE}}
        rescue StandardError => e
            # DB登録に失敗した場合
            json = {status:STATUS_ERROR, error: {message: e.message}}
        end

        render status: HTTP_STATUS_200, json: json
    end

    def destroy
        begin
            params.require(:id)
            task = Task.find(params[:id])

            if task.nil?
                raise StandardError, TASK_EXIST_MESSAGE
            end

            task.soft_delete!
            json = {status:STATUS_SUCCESS}
        rescue ActionController::ParameterMissing => e
            # 未入力の場合
            json = {status:STATUS_ERROR, error:{message: BAD_REQUEST_MESSAGE}}
        rescue StandardError => e
            # DB登録に失敗した場合
            json = {status:STATUS_ERROR, error:{message: e.message}}
        end

        render status: HTTP_STATUS_200, json: json
    end
end
