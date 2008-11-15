require File.dirname(__FILE__) + '/../test_helper'

require 'stats_controller'

# Re-raise errors caught by the controller.
class StatsController; def rescue_action(e) raise e end; end

class StatsControllerTest < Test::Unit::TestCase

  def setup
    @controller = StatsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list_contains_all_editors
    get :list
    Editor.find_all.each do |editor|
      assert_tag :tag => "div", :attributes => {:id => editor.name }
    end
  end

  def test_list_contains_all_post_counts
    get :list
    Editor.find_all.each do |editor|
      assert_tag :tag => "div", :attributes => {:id => "#{editor.name}_post_count"}, :content => editor.get_post_count.to_s
    end
  end

  def test_list_contains_all_review_counts
    get :list
    Editor.find_all.each do |editor|
      assert_tag :tag => "div", :attributes => {:id => "#{editor.name}_review_count"}, :content => editor.get_review_count.to_s
    end
  end

  def test_list_contains_all_reply_counts
    get :list
    Editor.find_all.each do |editor|
      assert_tag :tag => "div", :attributes => {:id => "#{editor.name}_reply_count"}, :content => editor.get_reply_count.to_s
    end
  end

end 

