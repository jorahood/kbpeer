class Timespan

  attr_reader :range, :start, :finish, :subspans, :editor_id, :editor, :subdivision
  
  @@subdivisions = ['none','week','month']
  
  def self.subdivisions
    @@subdivisions
  end
  
  def initialize(options = {})
    @editor_id = options[:editor_id]
    @editor = options[:editor]
    set_editor
    @start = options[:start] || Article.date_of_first_article
    @finish = options[:finish] || Article.date_of_last_article
    @subdivision = options[:subdivision]
    @range = (@start .. @finish)
    @subspans ||=  subdivide_timespan
  end

  def set_editor
    if @editor_id && @editor_id != ''
      @editor = Editor.find(@editor_id)
    end
  end
  
  #    FIXME: these chained methods are bad OO says the Law of Demeter. Refactor
  # them using delegates:
  #  http://dev.rubyonrails.org/browser/trunk/activesupport/lib/active_support/core_ext/module/delegation.rb

  def count_reviews_of
    @count_reviews_of ||= Review.of(editor).posted_within(self).count
  end
  
  def count_replies_to
    @count_replies_to ||= Reply.to(editor).posted_within(self).count
  end
  
  def count_posts
    @count_posts ||= (editor||Editor).posts.posted_within(self).count
  end
  
  def count_reviews
    @count_reviews ||= (editor||Editor).reviews.posted_within(self).count
  end
  
  def count_replies
    @count_replies ||= (editor||Editor).replies.posted_within(self).count
  end
  
  def count_docids
    @count_docids ||= (editor||Editor).posts.posted_within(self).count(:docid, :distinct => true)
  end
  
  def count_posts_with_no_reviews
    @count_posts_with_no_reviews ||= (editor||Editor).posts.posted_within(self).has_reviews(0).count
  end

  def count_posts_with_one_review
    @count_posts_with_one_review ||= (editor||Editor).posts.posted_within(self).has_reviews(1).count
  end

  def count_posts_with_two_reviews
    @count_posts_with_two_reviews ||= (editor||Editor).posts.posted_within(self).has_reviews(2).count
  end

  def count_posts_with_three_reviews
    @count_posts_with_three_reviews ||= (editor||Editor).posts.posted_within(self).has_reviews(3).count
  end

  def avg_reviews_per_post
    @avg_reviews_per_post ||= (editor||Editor).posts.posted_within(self).average(:reviews)
  end

  def calc_stats
    if editor
      count_reviews_of
      count_replies_to
    end
    count_posts
    count_reviews
    count_replies
    count_docids
    count_posts_with_no_reviews
    count_posts_with_one_review
    count_posts_with_two_reviews
    count_posts_with_three_reviews
    avg_reviews_per_post
    @subspans.each {|span| span.calc_stats}
  end
  
  private
    
  def subdivide_timespan
    # check that @subdivision exists and is valid
    if @subdivision == nil or @subdivision == '' or @subdivision == 'none'
      return []
    else
      raise "invalid subdivision" unless @subdivision == "week" or @subdivision == "month"
    end
    
    substart = @start
    subfinish = @finish
    spans = []
    loop do
      subfinish = self.send "add_a_#{@subdivision}", substart
      spans << (Timespan.new(:start=>substart,:finish=>subfinish, :editor=>@editor))
      break if subfinish == @finish 
      substart = subfinish + 1.day
    end
    return (spans.length > 1 ? spans : []) 
  end

  def add_a_week(date) 
    (date + 1.week <= @finish) ? date + 1.week : @finish
  end
  
  def add_a_month(date)
    ((date + 1.month) - 1.day <= @finish) ? (date + 1.month) - 1.day : @finish
  end
  
end