require File.dirname(__FILE__) + '/../spec_helper'

describe StatsController do

  describe "route generation" do

    it "should map { :controller => 'stats', :action => 'index' } to /" do
      route_for(:controller => "stats", :action => "index").should == "/"
    end
    
    describe "named routes" do
      
      it "should map 'stats' to /" do
        @timespan = mock(Timespan, :calc_stats => nil, :subspans => [])
        Timespan.stub!(:new).and_return(@timespan)
        get :index
        stats_path.should == '/'
      end
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'stats', action => 'index' } from GET /" do
      params_from(:get, "/").should == {:controller => "stats", :action => "index"}
    end

    it "should generate params { :controller => 'stats', action => 'index' } from GET /stats" do
      params_from(:get, "/stats").should == {:controller => "stats", :action => "index"}
    end

  end
end