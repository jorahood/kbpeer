class IndexMessageIdColumnForSpeedup < ActiveRecord::Migration
  def self.up
    add_index(:articles, :message_id)
  end

  def self.down
    remove_index(:articles, :message_id)
  end
end
