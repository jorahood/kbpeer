class GraphsController < ApplicationController
  model :editor
  model :article
  require 'rubygems'
  gem 'gruff'
  # To make caching easier, add a line like this to config/routes.rb:
  # map.graph "graph/:action/:id/image.png", :controller => "graph"
  #
  # Then reference it with the named route:
  #   image_tag graph_url(:action => 'show', :id => 42)
  
  def demo
    g = Gruff::Line.new
    # Uncomment to use your own theme or font
    # See http://colourlovers.com or http://www.firewheeldesign.com/widgets/ for color ideas
    #     g.theme = {
    #       :colors => ['#663366', '#cccc99', '#cc6633', '#cc9966', '#99cc99'],
    #       :marker_color => 'white',
    #       :background_colors => ['black', '#333333']
    #     }
    #     g.font = File.expand_path('artwork/fonts/VeraBd.ttf', RAILS_ROOT)
    
    g.title = "Gruff-o-Rama"
    g.stacked = 1
    g.data("Apples", [1, 2, 3, 4, 4, 20])
    g.data("Oranges", [4, 8, 7, 9, 8, 9])
    g.data("Watermelon", [2, 3, 1, 5, 6, 8])
    g.data("Bananas", [9, 9, 10, 8, 7, 9])
    
    g.labels = {0 => '2004', 2 => '2005', 4 => '2006'}
    
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
  end
  
  def overall
    graph = Gruff::Bar.new
    graph.legend_font_size = 12
    graph.title = "Docs Posted"
    editors = Editor.find_all_current.sort_by{|ed| ed.get_post_count}
    editors.each do |editor|
      graph.data(editor.name, [editor.get_post_count])
    end
    graph.labels = {0 => 'total posts'}
    
    send_data(graph.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
  end
  
  def render_it
    setup
    g = Gruff::Line.new
    g.title = "KBReview activity"
    @graph_data.each do |label,data|
      values = @timespans.map{|span| span[data.to_sym] || span[:reviews_per_post][data.to_i] } 
      g.data(label,values)
    end
    g.labels = @graph_labels
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
  end
end
