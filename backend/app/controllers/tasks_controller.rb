class TasksController < ApplicationController
    def index
        tasks = Task.all # todo:全件取得しているがページネーションにしたい
        render status: 200, json: { status: "OK", count: tasks.count, tasks: tasks }
    end

    def create
        begin
            params.require(:name)

            # 既に登録されているタスクかチェックする
            task = Task.find_by(name: params[:name])
            unless task.nil?
                raise StandardError, "既に登録されているタスクです"
            end

            task = Task.new
            task.name = params[:name]
            
            unless task.save!
                raise StandardError, "タスクの登録に失敗しました"
            end
            
            http_code = 200
            json = {status:"OK", data:{task:task}}
        rescue ActionController::ParameterMissing => e
            # 未入力の場合
            http_code = 400
            json = {status:"NG", message: "リクエストが不正です"}
        rescue StandardError => e
            # DB登録に失敗した場合
            http_code = 500
            status = "NG"
            json = {status:"NG", message: e.message}
        end

        # todo:パラメータが不正な場合にエラーを返せるようにしたい
        render status: http_code, json: json
    end

    def update
        begin
            params.require(:id)
            params.require(:name)

            task = Task.find_by(id: params[:id])
            task.name = params[:name]
            
            unless task.save!
                raise StandardError, "タスクの更新に失敗しました"
            end
            
            http_code = 200
            json = {status:"OK", data:{task:task}}
        rescue ActionController::ParameterMissing => e
            # 未入力の場合
            http_code = 400
            json = {status:"NG", message: "リクエストが不正です"}
        rescue StandardError => e
            # DB登録に失敗した場合
            http_code = 500
            status = "NG"
            json = {status:"NG", message: e.message}
        end

        render status: http_code, json: json
    end
end
