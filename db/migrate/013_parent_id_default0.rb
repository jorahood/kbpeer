class ParentIdDefault0 < ActiveRecord::Migration
  def self.up
    change_column (:articles, :parent_id, :integer, :default => 0, :null => false)
  end

  def self.down
    change_column (:articles, :parent_id, :integer)
  end
end
