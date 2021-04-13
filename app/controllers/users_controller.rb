class UsersController < ApplicationController
  def index
    @users = User.order('name asc')
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.get_voted(Article)
    
    if params[:order].present?
      @articles = @articles.order('id desc')
    else
      @articles = @articles.order('cached_votes_up desc')
    end

    @articles = @articles.page(params[:page])
  end
end
