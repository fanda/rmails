require "automateit"
require "rails"
require "rake"
require "bundler"


module Rmails
  class Installer
    def initialize
      @passwords = []
      @interpreter = AutomateIt.new(:project => "system")
      @interpreter.include_in(self)
      @interpreter.set :rake_task, Rake::Task
      @interpreter.set :rails_root, Rails.root
      @interpreter.set :passwords, @passwords
    end

    def run
      @interpreter.invoke '01_prepare_server'
      #Bundler.with_clean_env do
      #  @interpreter.shell_manager.sh("bundle install --without development assets")
      #end
      #@interpreter.invoke '02_setup_database'
      #@interpreter.invoke '03_setup_postfix'
      #@interpreter.invoke '04_setup_dovecot'
      @interpreter.invoke '05_setup_nginx'
      @interpreter.invoke '06_setup_dspam'
      @interpreter.invoke '07_setup_amavis'
      @interpreter.invoke '08_setup_spamassassin'
      @interpreter.invoke '09_setup_awstats'
      @interpreter.invoke 'XX_start_services'
    end



  end
end
