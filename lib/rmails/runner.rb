unless defined?(Bundler)
  require "automateit"
  require "rails"
  require "rake"
  require "bundler"
end

module Rmails
  class Runner
    def initialize
      @passwords = []
      @interpreter = AutomateIt.new(:project => "system")
      @interpreter.include_in(self)
      @interpreter.set :rake_task, Rake::Task
      @interpreter.set :rails_root, Rails.root
    end

    def start
      @interpreter.sh 'thin restart -C /etc/thin/rmails.yml'
    end

    def stop
      @interpreter.sh 'thin stop -C /etc/thin/rmails.yml'
    end


  end
end
