require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase

  fixtures :articles

  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_have_article_creation_form
    get :create
    assert_template 'admin/create'
    assert_tag :tag => 'textarea', 
      :attributes => {:name => 'article[rawtext]'},
      :parent => {:tag => 'form'}
    assert_tag :tag => 'input',
      :attributes => {:type => 'submit'}
  end

  def _test_should_have_import_form
    get :import
    assert_template 'admin/import'
    assert_tag :tag => 'form'
  end

  def _test_import_form_should_have_filename_field
    get :import
    assert_tag :tag => 'input', :attributes => {:name => 'filename'}
  end

  def _test_import_form_requires_filename
    post :import
    assert_response :redirect
    follow_redirect
    assert_tag :tag => 'div', :attributes => {:id => 'notice'}, :content => 'Please supply a filename.'
  end

  def _test_import_form_checks_if_file_exists
    post :import, {:filename => 'blah'}
    assert_response :redirect
    follow_redirect
    assert_tag :tag => 'div', :attributes => {:id => 'notice'}, :content => 'Could not locate file'
  end
end
