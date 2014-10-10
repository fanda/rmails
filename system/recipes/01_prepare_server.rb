
#
# Install system packages
#
puts 'xx Install tools'
package_manager.install %w( ntp perl awstats opendkim )

# they may be platform-specific
if tagged?("ubuntu|debian")
  puts 'xx Install apt specific'
  package_manager.install %w( build-essential libpq-dev sudo )

  postgres_packages = []#%w( postgresql )

  dovecot_packages = %w( dovecot-core dovecot-pgsql dovecot-pop3d dovecot-imapd dovecot-sieve dovecot-managesieved dovecot-lmtpd )
  dspam_packages = %w( dspam libdspam7-drv-pgsql )
  amavis_packages = %w( amavisd-new spamassassin )

  if tagged?("ubuntu")
    package_manager.install postgres_packages + dovecot_packages
    package_manager.install dspam_packages + amavis_packages

  else # this is debian

    package_manager.install postgres_packages + amavis_packages
    backports_packages = dovecot_packages + dspam_packages

    # we need to use backports - wheezy is actually stable branch
    backports_source = "deb http://backports.debian.org/debian/ wheezy-backports main"
    edit(:file => "/etc/apt/sources.list") do
      if contains? backports_source
        uncomment backports_source
      else
        append backports_source
      end
    end
    # update repo system
    puts "Getting Debian backports packages information..."
    shell_manager.sh "apt-get update > /dev/null 2>&1"

    package_manager.install backports_packages, :backports => 'wheezy-backports'
  end


elsif tagged?("fedora | centos")
  package_manager.install %w( gcc ruby-devel nginx postfix postgresql-server dovecot )

else # fail if running on another platform
  raise NotImplementedError.new("This platform has not been supported yet")

end

package_manager.install %w( postfix postfix-pgsql nginx )


#edit :file => '~/.gemrc' do
#  lines = "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri"
#  append lines unless contains? lines
#end

gems = %w( activerecord-postgresql-adapter pg paper_trail haml haml-rails jquery-rails chosen-rails simple_form )

begin
#  package_manager.install(gems, :with => :gem, :docs => false)
  puts "!! Gems installed"
rescue
end
render :file => "#{dist}rmails/Gemfile.2", :to => "#{rails_root}/Gemfile"

shell_manager.sh 'export PATH=/var/lib/gems/1.8/bin/:${PATH}'

account_manager.add_group('rmails')

render(
    :file   => "#{dist}sudoers",
    :to     => "/etc/sudoers",
    :mode   => 0440, :backup => false
)

# application private key
#passwords << server_key('/etc/rmails.key')
# remember password

#puts passwords.inspect
