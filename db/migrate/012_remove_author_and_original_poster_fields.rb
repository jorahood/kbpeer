class RemoveAuthorAndOriginalPosterFields < ActiveRecord::Migration
  def self.up
    remove_column :articles, :author
    remove_column :articles, :original_poster
  end

  def self.down
    add_column :articles, :author, :string
    add_column :articles, :original_poster, :string
  end
end
