class AddReference < ActiveRecord::Migration
  def self.up
    add_column :articles, :reference, :string
  end

  def self.down
    remove_column :articles, :reference
  end
end
