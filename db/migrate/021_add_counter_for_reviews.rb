class AddCounterForReviews < ActiveRecord::Migration
  def self.up
    add_column :articles, :reviews, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :reviews
  end
end
