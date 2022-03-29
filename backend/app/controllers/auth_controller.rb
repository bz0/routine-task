class AuthController < ApplicationController
    skip_before_action :require_login, only: [:create]

    PASSWORD = "test" # 固定パスワード
    
    def create
        token = ''
        status = :unauthorized
        if params[:password] == PASSWORD
            token = Session.create
            status = :created
        end
        render json: { token: token }, status: status
    end
end
