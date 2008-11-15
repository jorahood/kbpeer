require File.dirname(__FILE__) + '/../spec_helper'

module ArticleSpecHelper
  
  def required_article_attributes
    {
      :subject => "This is my subject",
      :message_id => 1  
    }
  end
  
  def stub_article_attributes_with_rawtext
    {
      :rawtext => "Subject: Parse this subject line correctly or else"
    }
  end

end

describe Article do

  include ArticleSpecHelper

  before(:each) do
    @article = Article.new
    @finish = Date.new(2007,12,20)
    @start = Date.new(2007,12,19)
  end

  it "should be valid" do
    @article.attributes = required_article_attributes 
    @article.should be_valid
  end
  
  it "should require subject" do
    @article.should have(1).error_on(:subject)
  end
  
  it "should require message_id" do
    @article.should have(1).error_on(:message_id)   
  end
  
  it "should require unique message_id" do
    @article.attributes = required_article_attributes
    @article.save
    Article.new(required_article_attributes).should_not be_valid
  end
  
  it "should find the date of the first article in the db" do
    first_article = Article.new(:date=>@start)
    Article.should_receive(:find).with(:first, :order => "date ASC").and_return(first_article)
    Article.date_of_first_article.should === first_article.date
  end
  
  it "should find the date of the last article in the db" do
    last_article = Article.new(:date=>@finish)
    Article.should_receive(:find).with(:first, :order => "date DESC").and_return(last_article)
    Article.date_of_last_article.should === last_article.date
  end
end

describe Article, ".parse_*" do       
  before(:each) do
    @article_parser = Article.new
    @article_parser.stub!(:rawtext).and_return(
      %Q[Path: cobincho.uits.indiana.edu!not-for-mail
From: "Andrew Orahood" <jorahood@paprika.uits.indiana.edu>
Newsgroups: kbreview
Subject: What about the IU-Corel License Agreement? (agsb in all)
Date: 2006-06-28 10:48:02
Message-ID: real_rawtext
References: Andy_wrote_9 Andy_wrote_Tim_reviewed_1

Julie Thatcher <jthatche@paprika.uits.indiana.edu> wrote:
> One thing.
>
> In article <20050613203913.95B5C42400@bell.ucs.indiana.edu>,
> Rich Moghtader <rmoghtad@bell.ucs.indiana.edu> wrote:
> >updated per meeting with SSED
> >-----------------begin-kbdoc---------
> >KB document agsb in domain all
> >
> >
> ><!-- $Id: agsb.kbml,v 1.11 2005/06/13 20:38:54 rmoghtad Exp $ -->
> ></kbml>])
  end
    
  it "should parse subject" do
    @article_parser.parse_subject.should ==
      "What about the IU-Corel License Agreement? (agsb in all)"
  end
    
  it "should parse editor name" do
    @article_parser.parse_editor.should == "jorahood"
  end
    
  it "should parse message id" do
    @article_parser.parse_message_id.should == "real_rawtext"
  end
    
  it "should parse reference id" do
    @article_parser.parse_reference.should == 
      "Andy_wrote_9 Andy_wrote_Tim_reviewed_1"
  end
    
  it "should parse date" do
    @article_parser.parse_date.should == "2006-06-28 10:48:02"
  end
    
  it "should parse docid" do
    @article_parser.parse_docid.should == "agsb"
  end
    
  it "should parse all attributes in one method" do
    @article_parser.should_receive(:parse_subject)
    @article_parser.should_receive(:parse_editor)
    @article_parser.should_receive(:parse_message_id)
    @article_parser.should_receive(:parse_reference)
    @article_parser.should_receive(:parse_date)
    @article_parser.should_receive(:parse_docid)
      
    @article_parser.parse_all
  end
end
  
describe Article, "importing the spool" do

  before(:all) do
    Article.delete_all #the db doesn't get automatically wiped since I'm not using fixtures
    @spool_file = File.read(RAILS_ROOT + "/spec/fixtures/testspool.txt")
    @spool_list = Article.break_spool_into_spool_list(@spool_file)
    @post_list = Article.make_unsaved_posts_from_spool_list(@spool_list)
    Article.array_into_tree_and_save(@post_list)
  end
      
  it "should break the spool down correctly" do
    @spool_list.length.should == 13
    @spool_list[0].should match(/sample_id_2/)
    @spool_list[-1].should match(/<20050415144110.AC804424E3@bell.ucs.indiana.edu>/)      
  end
    
  it "should turn a mail spool into an array of objects" do
    @post_list[0].class.should == Post
  end
    
  it "should turn an array into a nested set" do
    child_article = Article.find_by_message_id('sample_id_1')
    parent_article = Article.find_by_message_id('sample_id_2')
    child_article.parent_id.should == parent_article.id
  end
    
  it "should have one method to do the import start to finish" do
    Article.should_receive(:break_spool_into_spool_list).ordered.and_return @spool_list
    Article.should_receive(:make_unsaved_posts_from_spool_list).ordered.and_return @post_list 
    Article.should_receive(:array_into_tree_and_save).ordered 
    Article.import_spool(@spool_file)
  end
end
  
describe Article, "acting as threaded" do
   
  before do
    @article_review = Article.new(:parent_id=>1)
    @article_root = Article.new
  end

  it "should find its root" do
    @article_review.root_id = 1
    Article.should_receive(:find).with(1)
    @article_review.root
  end    

  it "should find its parent" do
    Article.should_receive(:find).with(1)
    @article_review.parent
  end    

  it "should set :depth and :root_id for children before create" do
    @article_root.root_id = 1
    @article_review.should_receive(:parent).twice.and_return( @article_root)
    @article_review.before_create 
    @article_review.depth.should == 1
    @article_review.root_id.should == 1
  end

  it "should not set :depth or :root_id for root before create" do
    lambda { @article_root.before_create}.should_not change( @article_root,:depth)      
    lambda { @article_root.before_create}.should_not change( @article_root,:root_id)      
  end

  it "should set :root_id to :id for root after create" do
    @article_root.id = 1 # #new won't set an :id you pass in so you have to do it manually
    @article_root.after_create
    @article_root.root_id.should == 1
  end
    
  it "should attach child to parent after create" do
    @article_review.id = 2
    article_child = Article.new(:parent_id => 2)
    article_child.id = 3
    Article.should_receive(:find).with(2).once.and_return(@article_review)
    @article_review.should_receive(:add_child)
    article_child.after_create
  end
end

describe Article, "subclassing reviews and replies" do
    
  before do
    @article_review = Article.new
    @article_root = Article.new
    @article_reply = Article.new
  end

  it "should recognize a review" do
    @article_review.should_receive(:child?).ordered.and_return(true)
    @article_review.should_receive(:root).ordered.and_return( @article_root)
    @article_root.should_receive(:full_set).ordered.and_return([ @article_root, @article_review])
    @article_review.should_receive(:editor).ordered.and_return(Editor.new)
    @article_root.should_receive(:editor).ordered.and_return(Editor.new)     
    @article_review.review?.should == true
  end
    
  it "should not call a reply a review" do
    same_editor = Editor.new
    @article_reply.should_receive(:child?).ordered.and_return(true)
    @article_reply.should_receive(:root).ordered.and_return( @article_root)
    @article_root.should_receive(:full_set).ordered.and_return([ @article_root, @article_review, @article_reply])
    @article_review.should_receive(:editor).ordered.and_return(same_editor)
    @article_reply.should_receive(:editor).ordered.twice.and_return(same_editor)
    @article_root.should_receive(:editor).ordered.and_return(Editor.new)
    @article_reply.review?.should == false
  end

  it "should set a review as a review" do
    @article_review.should_receive(:root).twice.and_return(@article_root)
    @article_root.should_receive(:save!)
    @article_review.set_as_review
    @article_review[:type].should == 'Review'
    @article_root.reviews.should == 1
  end
    
  it "should set a reply as a reply" do
    @article_review.set_as_reply
    @article_review[:type].should == 'Reply'      
  end
    
  it "should set :root_editor_id for reviews and replies" do
    @article_root.editor_id = 1
    @article_review.should_receive(:root).once.and_return( @article_root)
    @article_review.set_root_editor_id
    @article_review.root_editor_id.should == 1
  end

  it "should sort a review from list" do
    Article.should_receive(:find_reviews_and_replies).once.and_return([@article_review])
    @article_review.should_receive(:set_root_editor_id).ordered.once
    @article_review.should_receive(:review?).ordered.once.and_return(true)
    @article_review.should_receive(:set_as_review).ordered
    @article_review.should_receive(:save!).ordered
    Article.sort_reviews_and_replies
  end

  it "should sort a reply from list" do
    Article.should_receive(:find_reviews_and_replies).once.and_return([@article_reply])
    @article_reply.should_receive(:set_root_editor_id).ordered.once
    @article_reply.should_receive(:review?).ordered.once.and_return(false)
    @article_reply.should_receive(:set_as_reply).ordered
    @article_reply.should_receive(:save!).ordered
    Article.sort_reviews_and_replies
  end

  it "should find reviews and replies from list" do
    Article.should_receive(:find).once.with(:all, :conditions => 'reference IS NOT NULL')
    Article.find_reviews_and_replies
  end  
end

describe "has_finders" do
  
  before(:all) do
    @ed = Editor.new
    @ed[:id] = 1
  end

  describe Article do
    it "should have a 'posted_within' finder that takes a timespan param" do
      lambda {Article.posted_within(nil)}.should raise_error(
        RuntimeError, "missing a timespan parameter")
    end
 
    it "should have 'posted_within' finder that takes a timespan param that adds a :date => :range condition" do
      timespan = Timespan.new(:start => Date.new(2007,12,27), :finish => Date.new(2008,2,28), :subdivision => "month") 
      Article.posted_within(timespan).proxy_scope.should == {:conditions => {:date =>timespan.range}}
    end  

    it "should have a 'has_reviews' finder" do
      n = 1
      Post.has_reviews(n).proxy_scope.should == {:conditions => {:reviews => n}}
    end
  end

  describe Review do
    it "should have an 'of' finder that takes an editor parameter" do
      lambda {Review.of(nil)}.should raise_error(RuntimeError, "missing an 'editor' parameter")
    end
    
    it "should have an 'of' finder that adds a :root_editor_id condition" do
      Review.of(@ed).proxy_scope.should == {:conditions => {:root_editor_id => @ed[:id]}}
    end
    
  end
  describe Reply do
    it "should have a 'to' finder that takes an editor parameter" do
      lambda {Reply.to(nil)}.should raise_error(RuntimeError, "missing an 'editor' parameter")
    end
    
    it "should have a 'to' finder that adds a :root_editor_id condition" do
      Reply.to(@ed).proxy_scope.should == {:conditions => {:root_editor_id => @ed[:id]}}
    end
    
  end
end
