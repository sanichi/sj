set :application, "sj"
set :repo_url, "git@bitbucket.org:sanichi/sj.git"
set :log_level, :info
append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
