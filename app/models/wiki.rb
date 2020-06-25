class Wiki < ApplicationRecord
  belongs_to :wiki_category

  paginates_per 36

  scoped_search on: [:title]

  scope :recent, -> { order('id DESC') }
  scope :hot, -> { order('hot_scored_datestamp DESC').order('hot_score DESC').order('likes_count DESC') }
end
