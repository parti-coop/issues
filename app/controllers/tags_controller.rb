class TagsController < ApplicationController
  def index
    @tags = Article.tag_counts_on(:tags)
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @order = params[:order] || "popular"
    @articles = Article.tagged_with(@tag)
  end
end
