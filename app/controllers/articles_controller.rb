class ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create_by_slack
  load_and_authorize_resource
  HASHTAG_REGEX = /(?:\s|^)(#(?!(?:\d+|[ㄱ-ㅎ가-힣a-z0-9_]+?_|_[ㄱ-ㅎ가-힣a-z0-9_]+?)(?:\s|$))([ㄱ-ㅎ가-힣a-z0-9\-_]+))/i

  def index
    sort = params[:sort] || 'recent'
    tag = params[:tag]
    @articles = tag.present? ? Article.tagged_with(tag).send(sort).recent.page(params[:page]) : Article.send(sort).recent.page(params[:page])
  end

  def new
    @article = Article.new
  end

  def create
    @article.user = current_user
    hastag
    if @article.save
      CrawlingJob.perform_async(@article.id)
      redirect_to articles_path(sort: :recent)
    else
      errors_to_flash(@article)
      render :new
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

  def article_params
    params.require(:article).permit(:url, :body)
  end

  def hastag
    return if @article.body.blank?
    strip_body = Nokogiri::HTML(@article.body).xpath('//text()').map(&:text).join(' ').gsub("&nbsp;", " ")
    @article.tag_list = strip_body.scan(HASHTAG_REGEX).map { |match| match[1] }.join(', ')
  end
end
