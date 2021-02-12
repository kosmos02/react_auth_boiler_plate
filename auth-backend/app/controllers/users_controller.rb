class UsersController < ApplicationController
    
    def index
        @users = User.all

        render json: @users
    end

    def create
        @user = User.create(user_params)

        render json: @user, status: :created
    end

    def login
        @user = User.find_by(username: params[:user][:username])
        if @user && @user.authenticate(params[:user][:password])
            @token = JWT.encode([user_id: @user.id], ENV['SECRET_KEY_BASE'])
        
            render json: {user: @user, token: @token}
        else
            render json: {error: "Invalid Credentials"}, status: :unauthorized
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password, :name, :title, :phone_number, :email)
    end

end
