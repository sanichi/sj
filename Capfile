# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
require "capistrano/bundler"
require "capistrano/passenger"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"

# Include local tasks.
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
