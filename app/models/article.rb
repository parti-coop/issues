class Article < ApplicationRecord
  # include Likable

  # acts_as_taggable
  paginates_per 20

  belongs_to :user, optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  scope :recent, -> { order('id DESC') }
  scope :hot, -> { order('hot_scored_datestamp DESC').order('hot_score DESC').order('likes_count DESC') }

  # mount
  mount_uploader :image, ImageUploader

  after_initialize :set_crawling_status

  def set_crawling_data(data)
    self.metadata = data.metadata.to_json || self.metadata
    self.title = data.title || self.title
    self.image = (data.image_io if data.image_io) || self.image
    self.image_width = (data.image_width if data.image_io) || self.image_width
    self.image_height = (data.image_height if data.image_io) || self.image_height
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
