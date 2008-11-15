# this was cut out from article.rb and put in a separate file because
# ActiveSupport couldn't find Post in article.rb after I upgraded to Rails 2.0
# since you can't specify the dependency using model() in the controller anymore.
# See the FIXME comment in application.rb
class Post < Article

end
