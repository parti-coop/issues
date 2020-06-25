class CreateWikiCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :wiki_categories do |t|
      t.string :title
      t.integer :seq, default: 0
    end

    change_table :wikis do |t|
      t.belongs_to :wiki_category
    end

    %w(이슈 아젠다 정책 사례).each_with_index do |category, i|
      WikiCategory.create(title: category, seq: i)
    end
  end
end
