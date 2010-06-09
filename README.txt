This app imports the spool from the kbreview Usenet forum, using
acts_as_nested_set to preserve the threading of the posts. It applies
a few rules to analyze the nature of the posts:

1. The first post in a thread is a Post requesting peer review of a document.
2. The first child posts by authors other than the original author are Reviews of the document.
3. Any other posts by the authors of 1. or 2. are Replies to peer review comments.

Once the posts have been analyzed into Posts, Reviews, and Replies,
they are broken down by time period and displayed per author, both of
which are user-selectable. After selecting a user and time period, the
message totals can be turned into a line graph.

Application notes

* Application deployment is done with capistrano and deprec. See config/deploy.rb for configuration details, and Application deployment steps below.
* kbpeer requires a file be copied from kb-dev.indiana.edu. There are cronjobs running on kb-dev.indiana.edu to:
    a. create the file from the kbreview newsgroup spool:
        55 23 * * * ls -1 /var/spool/news/articles/kbreview |sort -n|xargs -i cat  /var/spool/news/articles/kbreview/{} > /home/jorahood/kbreview.txt

    b. scp the file to the (test-)kbpeer.uits.iu.edu server(s).
        05 0 * * * scp -i /home/jorahood/kbpeer_rsa /home/jorahood/kbreview.txt test-kmtools.uits.iu.edu:/tmp
        10 0 * * * scp -i /home/jorahood/kbpeer_rsa /home/jorahood/kbreview.txt kmtools.uits.iu.edu:/tmp

* the rake task that does the importing is called kbpeer:import. It is set up to run by cron with the craken plugin.
The file to configure if you want to change the schedule is config/craken/raketab

Application deployment:
1. cap {staging|prod} deploy:setup
2. cap {staging|prod} deploy
3. cap {staging|prod} craken:install
4. cap {staging|prod} deploy:migrate
5. scp config/kbpeer_rsa.pub (test-)kbpeer.uits.iu.edu:.ssh
6. ssh to (test-)kbpeer.uits.iu.edu and
      cat config/kbpeer_rsa.pub >> authorized_keys
7. ssh to kb-dev.indiana.edu and
      scp kbreview.txt to (test-)kbpeer.uits.iu.edu:/tmp
8. ssh to (test-)kbpeer.uits.iu.edu and
      cd /opt/apps/kbpeer/current && rake kbpeer:import RAILS_ENV=production
