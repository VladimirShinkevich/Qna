# Load DSL and set up stages
require "capistrano/setup"

require "capistrano/scm/git"
require "capistrano/deploy"
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails"
require "capistrano/passenger"
require 'capistrano/ssh_doctor'
require 'capistrano/sidekiq'
require 'whenever/capistrano'
require 'thinking_sphinx/capistrano'

install_plugin Capistrano::SCM::Git
#install_plugin Capistrano::Sidekiq
#install_plugin Capistrano::Sidekiq::Systemd

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
