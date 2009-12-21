Kbpeer application notes
* the application deployment is handled by capistrano and deprec, using the multistaging extensions in capistrano-ext. See config/deploy.rb for configuration details.
* kbpeer requires a file be copied from kb-dev.indiana.edu. There are cronjobs running on kb-dev.indiana.edu to:
    1. create the file from the kbreview newsgroup spool:
        55 23 * * * ls -1 /var/spool/news/articles/kbreview |sort -n|xargs -i cat  /var/spool/news/articles/kbreview/{} > /home/jorahood/kbreview.txt

    2. scp the file to the (test-)kbpeer.uits.iu.edu server(s).
        05 0 * * * scp -i /home/jorahood/.ssh/kbpeer_rsa /home/jorahood/kbreview.txt test-kmtools.uits.iu.edu:
        10 0 * * * scp -i /home/jorahood/.ssh/kbpeer_rsa /home/jorahood/kbreview.txt kmtools.uits.iu.edu:

* the rake task that does the importing is called kbpeer:import. It is set up to run by cron with the craken plugin. The file to configure if you want to change the schedule is config/craken/raketab

Application deployment:
1. cap deploy:setup
2. cap deploy
3. ssh to server and append RAILS_ROOT/config/kbpeer_rsa.pub to authorized_keys
4. cap craken:install