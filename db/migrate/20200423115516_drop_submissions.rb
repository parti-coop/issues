class DropSubmissions < ActiveRecord::Migration[5.2]
  def change
    drop_table :submissions do |t|
      t.bigint "user_id"
      t.bigint "article_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["article_id"], name: "index_submissions_on_article_id"
      t.index ["user_id"], name: "index_submissions_on_user_id"
    end
  end
end
