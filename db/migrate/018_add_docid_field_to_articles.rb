class AddDocidFieldToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :docid, :string
  end

  def self.down
    remove_column :articles, :docid
  end
end
