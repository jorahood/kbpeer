class CreateEditors < ActiveRecord::Migration
  def self.up
    create_table(:editors) do |t|
      t.column :name, :string
      t.column :full_name, :string
      t.column :docs_posted, :integer
      t.column :docs_reviewed, :integer
    end
    add_column :articles, :editor_id, :integer
  end

  def self.down
    drop_table :editors
    remove_column :articles, :editor_id
  end
end
