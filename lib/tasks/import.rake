namespace :kbpeer do
  desc "Import the kbreview spool file. <file> defaults to /tmp/kbreview.txt"
  # rake tasks with arguments: http://rake.rubyforge.org/files/doc/release_notes/rake-0_8_3_rdoc.html
  task :import, :spool_file, :needs => :environment do |t, args|
    # args.with_defaults: http://dev.nuclearrooster.com/2009/01/05/rake-task-with-arguments/
    args.with_defaults(:spool_file => "/tmp/kbreview.txt")
    Article.delete_all
    spool = File.read(args.spool_file)
    spool_list = Article.break_spool_into_spool_list(spool)
    article_list = Article.make_unsaved_posts_from_spool_list(spool_list)
    Article.array_into_tree_and_save(article_list)
    puts "#{Article.find(:all).size} articles imported" unless RAILS_ENV == 'test'
    Article.sort_reviews_and_replies
    puts "...cast to reviews and replies" unless RAILS_ENV == 'test'
  end
end