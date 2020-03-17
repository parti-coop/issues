class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.text     "url",                   limit: 65535
      t.text     "body",                  limit: 65535
      t.string   "title"
      t.text     "desc",                  limit: 65535
      t.text     "metadata",              limit: 65535
      t.string   "image"
      t.string   "page_type"
      t.string   "crawling_status"
      t.datetime "crawled_at"
      t.string   "site_name"
      t.integer  "image_height",                        default: 0
      t.integer  "image_width",                         default: 0
      t.belongs_to  "user"
      t.integer  "likes_count",                         default: 0
      t.integer  "comments_count",                      default: 0
      t.integer  "anonymous_likes_count",               default: 0
      t.datetime "created_at",                                      null: false
      t.datetime "updated_at",                                      null: false
      t.integer  "hot_score",                           default: 0
      t.string   "hot_scored_datestamp"
      t.timestamps
    end
  end
end
