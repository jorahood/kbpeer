class RenameExIsEx < ActiveRecord::Migration
  def self.up
    rename_column :editors, :ex, :is_ex
  end

  def self.down
    rename_column :editors, :is_ex, :ex
  end
end
