#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'rake/dsl_definition'
require File.expand_path('../config/application', __FILE__)
Rmails::Application.load_tasks


require "rmails/installer"


=begin
desc "Interactive AutomateIt shell"
task :automateit do
  @interpreter = AutomateIt.new(:project => "system")
  @interpreter.include_in(self)
  AutomateIt::CLI.run
=end

namespace :system do
  desc "Prepare server by installing required software"
  task :install do
    setup = Rmails::Installer.new
    setup.run
    #@interpreter = AutomateIt.new(:project => "system")
    #@interpreter.include_in(self)
    #@interpreter.set :rake_task, Rake::Task
    #@interpreter.set :rails_root, Rails.root
    #invoke '01_prepare_server'
  end
end
