class TasksController < ApplicationController
    def index
        tasks = Task.all
        render status: 200, json: { tasks: tasks }
    end

    def create
        @task = Task.new(name: params[:post][:name]) # パラメータをそのまま引数に入れることに抵抗感がある、バリデーションを通してから入れたい

        if (@task.valid?) {
            task.save
            status = 200
            json = { task: task }
        }else{
            status = 400 //リクエスト不正
            json = { error: "タスク名が未入力です" }
        }

        render status: status, json: json
    end

    def update
        tasks = Task.all
        render status: 200, json: { tasks: tasks }
    end
end
