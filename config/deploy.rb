lock "~> 3.13.0"

set :application, "sni_sj_app"
set :repo_url, "git@bitbucket.org:sanichi/sni_sj_app.git"
set :log_level, :info
append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
