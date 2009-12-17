class Article < ActiveRecord::Base

  belongs_to :editor
  validates_presence_of :subject, :message_id
  validates_uniqueness_of :message_id
  acts_as_nested_set :scope => :root
  
  named_scope :posted_within, lambda { |timespan|
    raise "missing a timespan parameter" unless timespan.respond_to?(:range)
    {:conditions => {:date => timespan.range}}
  }
  
  named_scope :has_reviews, lambda { |number|
    raise "missing a 'number of reviews' parameter" unless number
    {:conditions => {:reviews => number}}
  }

  def self.date_of_first_article
    find(:first, :order => "date ASC").date
  end
  
  def self.date_of_last_article
    find(:first, :order => "date DESC").date
  end

  def self.import_spool(spool_file)
    delete_all
    spool_list = break_spool_into_spool_list(spool_file)
    article_list = make_unsaved_posts_from_spool_list(spool_list) 
    array_into_tree_and_save(article_list)
    puts "#{Article.find(:all).size} articles imported" unless RAILS_ENV == 'test'
    sort_reviews_and_replies
    puts "...cast to reviews and replies" unless RAILS_ENV == 'test'
  end

  def self.break_spool_into_spool_list(spool_file)
    spool_file.split(/^(?=Path:)/)
  end
  
  def self.make_unsaved_posts_from_spool_list(spool_list)
    article_list = [] 
    spool_list.each do |text|
      article = Post.new(:rawtext => text)
      article.parse_all
      # clear out the rawtext to improve db performance
      article.rawtext = nil 
      article_list.push article
    end
    return article_list
  end
  
  def self.array_into_tree_and_save(article_list)
    article_list.each_with_index do |article,i|
      if article.reference and article.reference =~ /(\S+)$/ and parent = find_by_message_id($1)
        # save article as a child node of parent
        article.parent_id = parent.id
      end
      article.save!
      puts i unless RAILS_ENV == 'test'
    end
  end

  def self.sort_reviews_and_replies
    reviews_and_replies = find_reviews_and_replies
    reviews_and_replies.each_with_index do |article,i|
      article.set_root_editor_id
      if article.review?
        article.set_as_review
        # otherwise it is a Reply
      else
        article.set_as_reply
      end
      article.save!
      puts i if RAILS_ENV == 'development'
    end
  end
  
  def set_root_editor_id
    self.root_editor_id = root.editor_id
  end
  
  # All the articles are posts right now. Find which ones should
  # actually not be posts; i.e., the ones with reference attributes. 
  def self.find_reviews_and_replies
    find(:all, :conditions => 'reference IS NOT NULL')
  end
  
  # A Review === the first child article by an editor in a tree. The second
  # condition reads "true if you cannot find another article by the same author
  # in this root's whole tree, including the root itself". We want to check the
  # root  also (using #full_set rather than #children  because an editor replying
  # to their own root post isn't reviewing. The reason this condition works to find the
  # first (i.e., lowest in the tree) article is because #f_r_a_r is run as each article is
  # being added to the tree, and the spool is in chronological order, so reviews
  # will always be the first article encountered in each tree for each editor.
  def review?    
    child? and !root.full_set.detect do |a| 
      a != self and a.editor == editor
    end
  end

  def set_as_review
    self[:type] = 'Review'
    root.reviews += 1
    root.save!
  end

  def set_as_reply
    self[:type] = 'Reply'
  end

  # methods :before_create, :after_create, :parent, and :root are from
  # http://i.nfectio.us/articles/2006/03/31/implement-acts_as_threaded-without-a-plugin
  def before_create
    # Update the child object with its parents attrs
    unless self[:parent_id].to_i.zero?
      self[:depth] = parent[:depth].to_i + 1
      self[:root_id] = parent[:root_id].to_i
    end
  end
  
  def after_create
    if self[:parent_id].to_i.zero?
      self[:root_id] = self[:id]
      self.save
    else
      parent.add_child(self)
    end
  end
    
  def parent
    @parent ||= Article.find(self[:parent_id])
  end

  def root
    @root ||= Article.find(self[:root_id])
  end

  def parse_reference
    rawtext =~ /^References: (.*)$/
    $1
  end

  def parse_editor
    rawtext =~ /^From: .*?(\w+)@/
    if $1
      $1.downcase 
      Editor.find_or_create_by_name($1)
      $1
    end
  end
    
  def parse_subject
    rawtext =~ /^Subject: (.*)/
    $1
  end

  def parse_message_id
    rawtext =~ /^Message-ID: (.*)/
    $1
  end

  def parse_date
    rawtext =~ /^Date: (.*)/
    $1
  end

  def parse_docid
    rawtext =~ /^Subject:.*\((\w{4})(?:-\w+)* in/
    #    rawtext =~ /(?:[\w>]*KB document ([a-z]{4}) in domain)
    $1
  end

  
  def parse_all
    self.editor = Editor.find_by_name(parse_editor)
    self.subject = parse_subject
    self.message_id = parse_message_id
    self.reference = parse_reference
    self.date = parse_date
    self.docid = parse_docid
  end
end
