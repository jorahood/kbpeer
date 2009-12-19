role :app, "test-kbpeer.uits.iu.edu"
role :web, "test-kbpeer.uits.iu.edu"
role :db,  "test-kbpeer.uits.iu.edu", :primary => true
role :cron, "test-kbpeer.uits.iu.edu" # for craken: http://github.com/latimes/craken/tree/master