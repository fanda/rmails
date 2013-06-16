unless defined?(Bundler)
  require "automateit"
  require "rails"
  require "rake"
  require "bundler"
end

module Rmails
  class Publisher
    def initialize(params={})
      @interpreter  = ::AutomateIt.new(:project => "system")
      @interpreter.include_in(self)
    end

    def run
      # prepare pre-install Gemfile
      @interpreter.render :file => "#{dist}rmails/Gemfile.1", :to => "#{Rails.root}/Gemfile", :backup => false
      Bundler.with_clean_env do
        @interpreter.shell_manager.sh("bundle install --without development assets")
      end

      # increase version number
      versions = []
      edit :file => "#{Rails.root}/lib/rmails/version.rb", :backup => false do
        replace /^\s*RELEASE.*$/, "  RELEASE = '#{Time.now.strftime('%Y-%m-%d')}'"
        manipulate do |content|
          content =~ /^\s*VERSION\s*=\s*['"](.*)['"].*$/
          versions = $1.split('.')
          versions[2] = (versions[2].to_i + 1).to_s
          content.gsub /^\s*VERSION.*$/, "  VERSION = '#{versions.join('.')}'"
        end
      end

      # publish on Rubygems and Github
      @interpreter.shell_manager.sh("gem build rmails.gemspec")
      @interpreter.shell_manager.sh("gem push rmails-#{versions.join('.')}.gem")

      @interpreter.shell_manager.sh("git commit -am 'version increased, rubygem published'")
      @interpreter.shell_manager.sh("git push")


      # prepare post-install/devel Gemfile
      @interpreter.render :file => "#{dist}rmails/Gemfile.2", :to => "#{Rails.root}/Gemfile", :backup => false
      Bundler.with_clean_env do
        @interpreter.shell_manager.sh("bundle install")
      end
    end
  end
end

