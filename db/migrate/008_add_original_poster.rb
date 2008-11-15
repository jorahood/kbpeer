class AddOriginalPoster < ActiveRecord::Migration
  def self.up
    add_column :articles, :original_poster, :string
  end

  def self.down
    remove_column :articles, :original_poster
  end
end
