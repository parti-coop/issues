class Article < ApplicationRecord
  paginates_per 36

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  acts_as_taggable
  acts_as_commentable
  acts_as_votable

  validates_format_of :url, :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\Z/i

  scoped_search on: [:title]

  scope :recent, -> { order(id: :desc) }
  scope :popular, -> { order('cached_weighted_total desc, id desc') }
  scope :hot, -> { order('hot_scored_datestamp DESC').order('hot_score DESC').order('likes_count DESC') }

  # mount
  has_one_attached :image

  after_initialize :set_crawling_status

  def set_crawling_data(data)
    self.metadata = data.metadata.to_json || self.metadata
    self.title = data.title || self.title
    self.image.attach(io: data.image_io, filename: data.image_original_filename) if data.image_io
    self.page_type = data.type || self.page_type
    self.desc = data.description || self.desc
    self.site_name = data.site_name || self.site_name
    self.crawling_status = :completed
    self.crawled_at = DateTime.now
  end

  def set_crawling_status
    self.crawling_status = 'not_yet' if self.new_record?
  end

  def image_present?
    self[:image].present?
  end

  def latest_comment_users
    comments.where.not(user: self.user).where.not(user: nil).recent.limit(20).map(&:user).uniq[0..7]
  end
end
