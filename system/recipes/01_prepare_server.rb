
puts tagged?("debian".bytes.to_a)

#
# Install system packages
#

system_packages = %w( perl awstats opendkim dspam libdspam7-drv-pgsql )

# they may be platform-specific
if tagged?("ubuntu|debian")
  system_packages += %w( build-essential libpq-dev nginx postfix postgresql )

  if tagged?("ubuntu")
    system_packages += %w( dovecot-common )
  else
    system_packages += %w( dovecot )
  end

elsif tagged?("fedora | centos")
  system_packages += %w( gcc ruby-devel nginx postfix postgresql-server dovecot )

else # fail if running on another platform
  raise NotImplementedError.new("This platform has not been supported yet")

end

package_manager.install system_packages


#
# Install Rails and supporting libraries with RubyGems
#

gems = %w( bundler pg automateit thin )

package_manager.install gems, {:with => :gem, :docs => false}

#
# Set system to do not download rubygems documentation
#

shell_manager.sh 'echo -e "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" >> ~/.gemrc'

#
# Bundle other application dependencies
#

shell_manager.sh 'bundle install'
