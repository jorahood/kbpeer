class ArticlesActsAsThreaded < ActiveRecord::Migration
  def self.up
  add_column :articles, :root_id, :integer
  add_column :articles, :lft, :integer
  add_column :articles, :rgt, :integer
  add_column :articles, :depth, :integer
  end

  def self.down
    remove_column :articles, :root_id
    remove_column :articles, :lft
    remove_column :articles, :rgt
    remove_column :articles, :depth
  end
end
