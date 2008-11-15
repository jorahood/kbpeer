class AddRawtext < ActiveRecord::Migration
  def self.up
    add_column 'articles', :rawtext, :text
  end

  def self.down
  end
end
