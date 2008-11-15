require File.dirname(__FILE__) + '/../spec_helper'

describe Timespan do
  before(:each) do
    @beginning = Date.new(2007,1,1)
    @end = Date.new(2012,1,1)
    @start = Date.new(2007,12,27)
    @finish = Date.new(2008,2,28)
    @subranges_by_month = [
      @start                     .. Date.new(2008,1,26), 
      Date.new(2008,1,27) .. Date.new(2008,2,26), 
      Date.new(2008,2,27) .. @finish]
    @date_opts = {:start => @start, :finish => @finish}
    @editor = mock_model(Editor)
    Editor.stub!(:find).and_return(@editor)
    @timespan = Timespan.new(@date_opts.merge(:subdivision => "month",
          :editor_id => @editor.id))
    @conds = { :conditions => {:date =>@timespan.range}, :select=>"id"}
  end

  it "should return a range from start to finish" do
    @timespan.range.should == (@start .. @finish)
  end
  
  it "should have a subdivision attribute" do
    @timespan.subdivision.should == "month"
  end
  
  it "should have an editor_id attribute" do
    @timespan.editor_id.should == @editor.id
  end
  
  it "should have an editor attribute" do
    @timespan.editor.should == @editor
  end
  
  it "should not cause an error if editor_id is blank " do
    @timespan_x = Timespan.new(@editor_id = '')
  end
  
  it "should have a Subdivision constant containing acceptable subdivision strings" do
    Timespan.subdivisions.should == ['none','week','month']
  end
  
  describe "subspans" do
   
    it "should inherit editor attribute from parent timespan" do
      @timespan.subspans[0].editor.should == @timespan.editor
    end
    
    it "should be stored in @subspans" do
      @timespan.subspans.map{|subspan| subspan.range}.should == @subranges_by_month
    end
  
    it "should return [] when there is no subdivision attribute" do
      timespan = Timespan.new(@date_opts.merge(:subdivision => nil))
      timespan.subspans.should == []
    end

    it "should return [] when subdivision = 'none' " do
      timespan = Timespan.new(@date_opts.merge(:subdivision => 'none'))
      timespan.subspans.should == []
    end    

    it "should return [] when subdivision = <empty string> " do
      timespan = Timespan.new(@date_opts.merge(:subdivision => ''))
      timespan.subspans.should == []
    end

    it "should return [] when timespan shorter than subdivision length" do
      short_timespan = Timespan.new(:start => Date.new(2007,1,1), 
        :finish=>Date.new(2007,1,2), :subdivision=> 'week')
      short_timespan.subspans.should == []
    end
  end
  
  it "should extract start and finish dates from the db if no dates provided in params" do
    Article.should_receive(:date_of_first_article).and_return(@beginning)
    Article.should_receive(:date_of_last_article).and_return(@end)
    timespan = Timespan.new
    timespan.start.should == @beginning
    timespan.finish.should == @end
  end
  
  it "should divide subspans correctly" do
    @timespan.subspans.each_with_index { |span,n| span.range.should == @subranges_by_month[n] }
  end

  describe "counting" do
  
    fixtures :articles
    
    before(:each) do
      @date_opts = {:start => Date.new(2005, 12, 27), :finish => Date.new(2006,8,28)}
      @timespan_all_editors = Timespan.new(@date_opts.merge(:subdivision => "month"))
      jorahood = Editor.new
      jorahood[:id] = 1
      Editor.stub!(:find).and_return(jorahood)
      @timespan = Timespan.new(@date_opts.merge(:subdivision => "month",:editor_id => 1))
      @subranges_by_month = [
        Date.new(2005,12,27).. Date.new(2006,1,26), #0
        Date.new(2006,1,27) .. Date.new(2006,2,26),  #1
        Date.new(2006,2,27) .. Date.new(2006,3,26),  #2
        Date.new(2006,3,27) .. Date.new(2006,4,26),  #3 
        Date.new(2006,4,27) .. Date.new(2006,5,26),  #4 
        Date.new(2006,5,27) .. Date.new(2006,6,26),  #5
        Date.new(2006,6,27) .. Date.new(2006,7,26),  #6
        Date.new(2006,7,27) .. Date.new(2006,8,26),  #7
        Date.new(2006,8,27) .. Date.new(2006,8,28),  #8
      ]
    end
    
    it "should count posts for all editors" do
      @timespan_all_editors.count_posts.should == 6
    end
        
    it "should count posts for one editor" do
      @timespan.count_posts.should == 4
    end
        
    it "should count reviews for all editors" do
      @timespan_all_editors.count_reviews.should == 6
    end
    
    it "should count reviews for one editor" do
      @timespan.count_reviews.should == 0
    end
        
    it "should count replies for all editors" do
      @timespan_all_editors.count_replies.should == 6
    end
            
    it "should count replies for one editor" do
      @timespan.count_replies.should == 3
    end
            
    it "should count posts with no reviews for all editors" do
      @timespan_all_editors.count_posts_with_no_reviews.should == 1
    end
        
    it "should count posts with no reviews for one editor" do
      @timespan.count_posts_with_no_reviews.should == 1
    end
    
    it "should count posts with one review for all editors" do
      @timespan_all_editors.count_posts_with_one_review.should == 4
    end
        
    it "should count posts with one review for one editor" do
      @timespan.count_posts_with_one_review.should == 2
    end
        
    it "should count posts with two reviews for all editors" do
      @timespan_all_editors.count_posts_with_two_reviews.should == 1
    end
        
    it "should count posts with two reviews for one editor" do
      @timespan.count_posts_with_two_reviews.should == 1
    end
        
    it "should count posts with three reviews for one editor" do
      @timespan.count_posts_with_three_reviews.should == 0
    end
        
    it "should count average reviews per post for all editors" do
      @timespan_all_editors.avg_reviews_per_post.should == 1.0
    end
    
    it "should count average reviews per post for one editor" do
      @timespan.avg_reviews_per_post.should == 1.0
    end
        
    it "should calculate all stats with one method for all editors" do
      @timespan_all_editors.should_receive(:count_posts)
      @timespan_all_editors.should_receive(:count_replies)
      @timespan_all_editors.should_receive(:count_reviews)
      @timespan_all_editors.should_receive(:count_posts_with_no_reviews)
      @timespan_all_editors.should_receive(:count_posts_with_one_review)
      @timespan_all_editors.should_receive(:count_posts_with_two_reviews)
      @timespan_all_editors.should_receive(:count_posts_with_three_reviews)
      @timespan_all_editors.should_receive(:avg_reviews_per_post)
      @timespan_all_editors.calc_stats
    end
    
    it "should calculate all stats with one method for one editor" do
      @timespan.should_receive(:count_posts)
      @timespan.should_receive(:count_replies)
      @timespan.should_receive(:count_reviews_of)
      @timespan.should_receive(:count_replies_to)
      @timespan.should_receive(:count_reviews)
      @timespan.should_receive(:count_posts_with_no_reviews)
      @timespan.should_receive(:count_posts_with_one_review)
      @timespan.should_receive(:count_posts_with_two_reviews)
      @timespan.should_receive(:count_posts_with_three_reviews)
      @timespan.should_receive(:avg_reviews_per_post)
      @timespan.calc_stats
    end

    describe "subspans" do

      it "should calculate stats recursively for subspans" do
        @timespan.subspans.each do |span|
          span.should_receive(:calc_stats)
        end
        @timespan.calc_stats
      end

      it "should calculate stats correctly for subspans" do
        @timespan.calc_stats
        span7 = @timespan.subspans[7]
        span7.count_posts.should == 1
        span7.count_reviews.should == 0
        span7.count_replies.should == 1
        span7.count_reviews_of.should == 0
        span7.count_replies_to.should == 0
        span7.avg_reviews_per_post.should == 2.0
        span7.count_posts_with_no_reviews.should == 0
        span7.count_posts_with_one_review.should == 0
        span7.count_posts_with_two_reviews.should == 1
        span7.count_posts_with_three_reviews.should == 0
        span7.count_docids.should == 1
      end
    end
  end
end
