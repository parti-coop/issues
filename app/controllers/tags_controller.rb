class TagsController < ApplicationController
  def index
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @order = params[:order] || "popular"
    @articles = Article.tagged_with(@tag)
  end
end
