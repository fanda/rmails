#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'rake/dsl_definition'
require File.expand_path('../config/application', __FILE__)
Rmails::Application.load_tasks

require "rmails/installer"
require "rmails/publisher"

namespace :rmails do

  desc "Prepare server by installing required software"
  task :install do
    setup = Rmails::Installer.new
    setup.run
  end


  desc "Task for developer. Increase version and distribute application on Rubygems and Github"
  task :publish do
    setup = Rmails::Publisher.new
    setup.run
  end

end
