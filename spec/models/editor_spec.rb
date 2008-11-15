require File.dirname(__FILE__) + '/../spec_helper'

describe Editor do
  before(:each) do
    @editor = Editor.new
  end

  it "should be valid" do
    @editor.should be_valid
  end

  it "should return Post class as a hack to let me not care if there is an editor selected when counting stuff" do
    Editor.posts.should == Post
  end

  it "should return Review class as a hack to let me not care if there is an editor selected when counting stuff" do
    Editor.reviews.should == Review
  end

  it "should return Reply class as a hack to let me not care if there is an editor selected when counting stuff" do
    Editor.replies.should == Reply
  end
end
