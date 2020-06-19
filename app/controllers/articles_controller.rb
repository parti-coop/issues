class ArticlesController < ApplicationController
  HASHTAG_REGEX = /(?:\s|^)(#(?!(?:\d+|[ㄱ-ㅎ가-힣a-z0-9_]+?_|_[ㄱ-ㅎ가-힣a-z0-9_]+?)(?:\s|$))([ㄱ-ㅎ가-힣a-z0-9\-_]+))/i

  before_action :set_article, only: [:show, :vote, :edit, :update, :destroy]

  def index
    if params[:q].present?
      @articles = Article.search_for(params[:q])
    else
      @articles = Article.all
    end

    @today = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @year = @today.year
    @week = @today.cweek
    @articles = @articles.by_year().by_cweek(@week).recent

    @order = params[:order] || "popular"
    if @order == "popular"
      @articles = @articles.popular
    else
      @articles = @articles.recent
    end
  end

  def show
    @comments = @article.comment_threads.order('created_at asc')
    @new_comment = Comment.build_from(@article, current_user.id, "") if user_signed_in?
  end

  def vote
    @article.liked_by current_user
  end

  def create
    @article = Article.find_by(url: params[:article][:url])
    @status = :new

    if @article.nil?
      @article = Article.new(article_params)
      @article.user = current_user
      if @article.save
        @article.liked_by current_user
        CrawlingJob.perform_async(@article.id)
      end
    else
      if @article.user != current_user
        @article.liked_by current_user
        @status = :vote_added
      else
        @status = :already_voted
      end
    end
  end

  def create_by_slack
    slack_text = params[:text]
    slack_token = params[:token]
    return if slack_text.blank? or slack_token != ENV['SLACK_ARTICLE_WEBHOOK_KEY']

    parsed_url = slack_text.scan(/https?:\/\/[\S]+/).first
    return if parsed_url.blank?
    parsed_url = parsed_url[0...-1] if parsed_url.last == '>'
    parsed_url = CGI.unescapeHTML parsed_url
    @article = Article.new(url: parsed_url, body: slack_text)
    hastag
    @article.save!
    CrawlingJob.perform_async(@article.id)
  end

  def edit
  end

  def update
    @article.assign_attributes(article_params)
    hastag
    if @article.save
      CrawlingJob.perform_async(@article.id)
      redirect_to article_path(@article)
    else
      errors_to_flash(@article)
      render :new
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:url, :body)
  end

  def hastag
    return if @article.body.blank?
    strip_body = Nokogiri::HTML(@article.body).xpath('//text()').map(&:text).join(' ').gsub("&nbsp;", " ")
    # @article.tag_list = strip_body.scan(HASHTAG_REGEX).map { |match| match[1] }.join(', ')
  end
end
