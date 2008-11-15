class Editor < ActiveRecord::Base

  has_many :articles
  has_many :reviews
  has_many :posts
  has_many :replies

  validates_uniqueness_of :name

  def self.find_all_current
    find_all_by_is_ex(nil)
  end
  
  def self.posts
    Post
  end

  def self.reviews
    Review
  end

  def self.replies
    Reply
  end
  
#  def docids_count(conds = {})
#    conditions = Article.make_condition_sql(conds)
#    conditions = "AND #{conditions}" if conditions
#    sql = "SELECT COUNT(distinct docid) FROM articles WHERE type = 'Post' AND editor_id = #{self.id} #{conditions}"
#    Article.count_by_sql(sql)
#  end
#
#  def docids(conds = {})
#    if posts = posts(conds) 
#      docids = posts.map{|post| post.docid||''}
#      docids.sort!
#    else
#      []
#    end
#  end

#  def posts_count(conds = {})
#    articles_count(:posts,conds)
#  end
#
#  def reviews_count(conds = {})
#    articles_count(:reviews,conds)
#  end
#
#  def replies_count(conds = {})
#    articles_count(:replies,conds)
#  end
#
#  def posts(conds = {})
#    articles(:posts,conds)
#  end
#
#  def reviews(conds = {})
#    articles(:reviews,conds)
#  end
#
#  def replies(conds = {})
#    articles(:replies,conds)
#  end

#  def reviews_per_post(conds = {})
#    conds[:editor] = self
#    Post.reviews_per_post(conds)
#  end
#
#  def avg_reviews_per_post(conds = {})
#    conds[:editor] = self
#    Post.avg_reviews_per_post(conds)
#  end

#  def articles(type_of,conds = {})
#    conditions = Article.make_condition_sql(conds)
#    # obj#send(:sym) is how you use a symbolic method name in
#    # Ruby. type_of is either :posts, :reviews, or :replies, so below,
#    # self.send(type_of).find will be turned into, e.g.,
#    # self.posts.find
#    self.send(type_of).find(:all, :conditions => conditions)
#  end
#
#  def articles_count(type_of,conds = {})
#    conditions = Article.make_condition_sql(conds)
#    conditions = "AND #{conditions}" if conditions
#    type_of = Inflector.camelize(Inflector.singularize(type_of))
#    sql = "SELECT COUNT(id) FROM articles WHERE type = '#{type_of}' AND editor_id = #{self.id} #{conditions}"
#    Article.count_by_sql(sql)
#  end
#
#  def make_subclass_name(type_of)
#        Inflector.camelize(Inflector.singularize(type_of))
#  end
  
end
