class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :article, foreign_key: true

      t.timestamps
    end

    Article.all.each do |article|
      Submission.create({article: article, user: article.user, created_at: article.created_at})
    end

    Comment.delete_all
  end
end
