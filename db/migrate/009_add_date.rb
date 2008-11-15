class AddDate < ActiveRecord::Migration
  def self.up
    add_column :articles, :date, :datetime
  end

  def self.down
    remove_column :articles, :date
  end
end
