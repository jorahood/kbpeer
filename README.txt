Kbpeer application notes
* the application deployment is handled by capistrano, using the multistaging extensions in capistrano-ext. See config/deploy.rb for configuration details.
* kbpeer requires a file be copied from kb-dev.indiana.edu. There are cronjobs running on kb-dev.indiana.edu to:
    1. create the file from the kbreview newsgroup spool:
        55 23 * * * ls -1 /var/spool/news/articles/kbreview |sort -n|xargs -i cat  /var/spool/news/articles/kbreview/{} > /home/jorahood/kbreview.txt

    2. scp the file to the kbpeer.uits.iu.edu server.
        