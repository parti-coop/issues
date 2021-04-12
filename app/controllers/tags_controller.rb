class TagsController < ApplicationController
  before_action :set_tags

  def index
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @order = params[:order] || "popular"
    @articles = Article.tagged_with(@tag)

    if params[:order].present?
      @articles = @articles.order('id desc')
    else
      @articles = @articles.order('cached_votes_up desc')
    end

    @articles = @articles.page(params[:page])
  end

  private

  def set_tags
    @tags = Article.tag_counts_on(:tags)
  end
end
