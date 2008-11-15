class RemoveReviewerHeadersBody < ActiveRecord::Migration
  def self.up
    remove_column :articles, :reviewer
    remove_column :articles, :headers
    remove_column :articles, :body
  end

  def self.down
    add_column :articles, :reviewer, :string
    add_column :articles, :headers, :text
    add_column :articles, :body, :text
  end
end
