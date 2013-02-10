#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Rmails::Application.load_tasks


require "automateit"



desc "Interactive AutomateIt shell"
task :automateit do
  @interpreter = AutomateIt.new(:project => "system")
  @interpreter.include_in(self)
  AutomateIt::CLI.run
end

desc "Prepare server by installing required software"
task :sysinst do
  @interpreter = AutomateIt.new(:project => "system")
  @interpreter.include_in(self)
  invoke "prepare_system"
end
