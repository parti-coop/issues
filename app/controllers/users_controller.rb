class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.get_voted(Article).recent.page(params[:page])
  end
end
