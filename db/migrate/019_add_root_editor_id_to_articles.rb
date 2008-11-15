class AddRootEditorIdToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :root_editor_id, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :root_editor_id
  end
end
