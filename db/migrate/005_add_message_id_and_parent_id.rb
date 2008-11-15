class AddMessageIdAndParentId < ActiveRecord::Migration
  def self.up
    add_column 'articles', :message_id, :string, :null => false
    add_column 'articles', :parent_id, :integer
    execute 'ALTER TABLE articles ADD CONSTRAINT article_id_fkey FOREIGN KEY (parent_id) REFERENCES articles (id);'
  end

  def self.down
    execute 'ALTER TABLE articles DROP FOREIGN KEY article_id_fkey;'
    remove_column 'articles', :message_id
    remove_column 'articles', :parent_id
  end
end
