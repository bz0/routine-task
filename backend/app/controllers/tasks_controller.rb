class TasksController < ApplicationController
    def index
        tasks = Task.all # todo:全件取得しているがページネーションにしたい
        render status: 200, json: { tasks: tasks }
    end

    def create
        begin
            params.require(:name)

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
            p [:e, e]
            # DB登録に失敗した場合
            http_code = 500
            status = "NG"
            json = {status:"NG", message: e.message}
        end

        # todo:パラメータが不正な場合にエラーを返せるようにしたい
        render status: http_code, json: json
    end

    def update
        tasks = Task.all
        render status: 200, json: { tasks: tasks }
    end
end
