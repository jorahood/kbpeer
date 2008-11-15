ActionController::Routing::Routes.draw do |map|
#  map.resources :stats
  map.stats '', :controller => "stats", :action => 'index'

  map.connect 'stats', :controller => "stats", :action => "index"


end
