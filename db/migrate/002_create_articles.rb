class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table "articles", :force => true do |t|
      t.column :body, :text
      t.column :subject, :string
      t.column :headers, :text
      t.column :author_first, :string
      t.column :author_last, :string
      t.column :reviewer_first, :string
      t.column :reviewer_last, :string
    end
  end

  def self.down
    drop_table :articles
  end
end
