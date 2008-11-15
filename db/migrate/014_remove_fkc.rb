class RemoveFkc < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE articles DROP FOREIGN KEY article_id_fkey;'
  end

  def self.down
    execute 'ALTER TABLE articles ADD CONSTRAINT article_id_fkey FOREIGN KEY (parent_id) REFERENCES articles (id);'
  end
end
