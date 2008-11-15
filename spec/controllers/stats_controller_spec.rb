require File.dirname(__FILE__) + '/../spec_helper'

describe StatsController do

  def go!(my_params={})
    get :index, my_params
  end
      
  before(:each) do
    @timespan = mock(Timespan)
    Timespan.stub!(:new).and_return(@timespan)
    @editor = mock_model(Editor)
    @timespan.stub!(:calc_stats)
    @timespan.stub!(:subspans).and_return([])
    Editor.stub!(:find).and_return(@editor)
    @my_params = {'timespan' =>{
        "start(1i)"=> "2007","start(2i)"=>"12","start(3i)"=>"27", 
        "finish(1i)"=>"2008","finish(2i)"=>"2","finish(3i)"=>"28",
        'editor_id' => @editor.id,
        'subdivision' => 'month'
      }}
  end
  
  it "should be successful" do
    go!
    response.should be_success
  end

  it "should render index template" do
    go!
    response.should render_template('index')
  end
  
  it "should create a timestamp object" do
    Timespan.should_receive(:new).and_return(@timespan)
    go!
  end
  
  it "should create a default Timespan object when no params submitted" do
    Timespan.should_receive(:new).with(
      :start =>nil, 
      :finish =>nil, 
      :editor_id =>nil,
      :subdivision => nil
    ).and_return(@timespan)
    go!
  end  
  
  it "should turn date params into date objects" do
    Timespan.should_receive(:new).with(
      :start =>Date.new(2007,12,27), 
      :finish =>Date.new(2008,2,28), 
      :editor_id => @editor.id,
      :subdivision => "month"
    ).and_return(@timespan)
    go!(@my_params)
  end
  
  it "should find all current editors" do
    Editor.should_receive(:find_all_current)
    go!
  end
  
  it "should assign all current editors to @editors" do
    Editor.should_receive(:find_all_current).and_return([@editor])
    go!  
    assigns[:editors].should == [@editor]
  end
  
end
