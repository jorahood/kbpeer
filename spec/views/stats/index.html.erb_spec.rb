require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stats/index" do

  before(:each) do
    @editor = mock_model(Editor, :name => 'bubba')

    @timespan_w_ed = mock(Timespan)
    add_stubs(@timespan_w_ed, 
      :start =>Date.yesterday,
      :finish => Date.today,
      :subdivision => 'month',
      :editor => @editor,
      :editor_id => @editor_id,
      :subspans => [@timespan_w_ed],
      :count_posts => 0,
      :count_docids => 0,
      :count_reviews => 0,
      :count_replies => 0,
      :count_reviews_of => 0,
      :count_replies_to => 0,
      :avg_reviews_per_post => 0,
      :count_posts_with_no_reviews => 0,
      :count_posts_with_one_review => 0,
      :count_posts_with_two_reviews => 0,
      :count_posts_with_three_reviews => 0)
    
    @timespan_no_ed = mock(Timespan)
    add_stubs(@timespan_no_ed, 
      :subdivision => "month", 
      :start => Date.yesterday,
      :finish => Date.today,
      :editor=>nil,
      :editor_id=>nil,
      :subspans => [@timespan_no_ed],
      :count_posts => 0,
      :count_docids => 0,
      :count_reviews => 0,
      :count_replies => 0,
      :count_reviews_of => 0,
      :count_replies_to => 0,
      :avg_reviews_per_post => 0,
      :count_posts_with_no_reviews => 0,
      :count_posts_with_one_review => 0,
      :count_posts_with_two_reviews => 0,
      :count_posts_with_three_reviews => 0)

    @timespan = @timespan_w_ed
  end
  
  def go!
    assigns[:timespan] = @timespan
    assigns[:editors] = [@editor]
    assigns[:subdivisions] = Timespan.subdivisions
    render 'stats/index'
  end

  it "should have a form" do
    go!
    response.should have_tag("form[action=?][method=?]", stats_path, 'post')
  end

  it "should have an editor_id select" do
    go!
    response.should have_tag("select[name='timespan[editor_id]']")
  end  
  
  it "should have a subdivision input" do
    go!
    response.should have_tag("input[name=?][type='radio']", "timespan[subdivision]")
  end

  it "should have select elements for start dates" do
    go!
    response.should have_tag('select[name=?]', 'timespan[start(1i)]')
    response.should have_tag('select[name=?]', 'timespan[start(2i)]')
    response.should have_tag('select[name=?]', 'timespan[start(3i)]')
  end
  
  it "should have select elements for finish dates" do
    go!
    response.should have_tag('select[name=?]', 'timespan[finish(1i)]')
    response.should have_tag('select[name=?]', 'timespan[finish(2i)]')
    response.should have_tag('select[name=?]', 'timespan[finish(3i)]')
  end
  
  it "should not display reviews_of or replies_to headers when there is not an editor" do
    @timespan = @timespan_no_ed
    go!
    response.should_not have_tag('th#reviews_of')
    response.should_not have_tag('th#replies_to')
  end
  
  it "should render the timespan partial for each subspan" do
    template.expect_render(:partial => 'timespan', :collection => @timespan.subspans)
    go!
  end
  
  it "should render the timespan partial once for the timespan object for totals" do
    template.expect_render(:partial => 'timespan', :object => @timespan)
    go!
  
  end
end
