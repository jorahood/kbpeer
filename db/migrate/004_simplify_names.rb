class SimplifyNames < ActiveRecord::Migration
  def self.up
    remove_column :articles, :author_first
    remove_column :articles, :author_last
    remove_column :articles, :reviewer_first
    remove_column :articles, :reviewer_last
    add_column :articles, :author,   :string
    add_column :articles, :reviewer, :string
  end

  def self.down
    add_column :articles, :author_first, :string
    add_column :articles, :author_last, :string
    add_column :articles, :reviewer_first, :string
    add_column :articles, :reviewer_last, :string
    remove_column :articles, :author
    remove_column :articles, :reviewer
  end
end
