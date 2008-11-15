
class AdminController < ApplicationController

  def create
    if request.post?
      @article = Article.new(:rawtext => @params[:article])
      @article.parse_all
      @article.save!
    end
  end

  def import
    if request.post?
      file = @params[:filename]
      if file and file.length > 0 and File.exist?("/home/jorahood/#{file}") 
        
      else
        flash[:notice] = "Could not locate file '/home/jorahood/#{file}'."
        flash[:notice] = "Please supply a filename." unless file && file.length > 0
        redirect_to :action => "import"
      end
    end
  end
end
