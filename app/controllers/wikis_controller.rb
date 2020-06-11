class WikisController < ApplicationController
  HASHTAG_REGEX = /(?:\s|^)(#(?!(?:\d+|[ㄱ-ㅎ가-힣a-z0-9_]+?_|_[ㄱ-ㅎ가-힣a-z0-9_]+?)(?:\s|$))([ㄱ-ㅎ가-힣a-z0-9\-_]+))/i

  before_action :set_wiki, only: [:show, :edit, :update, :destroy]

  def index
    @wikis = Wiki.recent.page(params[:page])
  end

  def new
    @wiki = Wiki.new
  end

  def show
  end

  def create
    @wiki = Wiki.new(wiki_params)
    if @wiki.save
      redirect_to wiki_path(@wiki)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @wiki.assign_attributes(wiki_params)
    if @wiki.save
      redirect_to wiki_path(@wiki)
    else
      render :edit
    end
  end

  def destroy
    @wiki.destroy
    redirect_to wikis_path
  end

  private

  def set_wiki
    @wiki = Wiki.find(params[:id])
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
end
