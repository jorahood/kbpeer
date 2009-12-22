Kbpeer application notes
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
      cd /opt/apps/kbpeer && rake kbpeer:import RAILS_ENV=production
