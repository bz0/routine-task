class TasksController < ApplicationController
    def index
        tasks = Task.all
        render status: 200, json: { tasks: tasks }
    end

    def create
        @task = Task.new(name: params[:name]) # paramsをそのまま入れたくない
        @task.save

        # todo:パラメータが不正な場合にエラーを返せるようにしたい
        render status: 200, json: { status: "OK" }
    end

    def update
        tasks = Task.all
        render status: 200, json: { tasks: tasks }
    end
end
