class FilterExEditors < ActiveRecord::Migration
  def self.up
    add_column :editors, :ex, :boolean
  end

  def self.down
    remove_column :editors, :ex
  end
end
