if tagged?("ubuntu | debian")
  etc_postfix = '/etc/postfix'
  dovecot_path = '/usr/lib/dovecot/deliver'
elsif tagged?('fedora | centos')
  etc_postfix = '/etc/postfix'
  dovecot_path = '/usr/lib/dovecot/deliver'
end

adapter = lookup('postfix#database#adapter')


#
# Set database query files
#
locals = {
    :name     => lookup('postfix#database#name'),
    :user     => lookup('postfix#database#user'),
    :host     => lookup('postfix#database#host'),
    :password => lookup('postfix#database#password')
}

db_query_files = %w(
                    sender_login_maps.cf
                    virtual_mailbox_domains.cf
                    virtual_mailbox_maps.cf
                    virtual_alias_maps.cf
                    email2email.cf            )

db_query_files.each do |file|
  render(
    :file   => "#{dist}postfix/#{file}.erb",
    :to     => "#{etc_postfix}/#{adapter}/#{file}",
    :mode   => 0555,
    :locals => locals
  )
end
shell_manager.chown('root', 'postfix', "#{etc_postfix}/#{adapter}/*")
#XXX 0555 ==? shell_manager.chmod('o=', "#{}/.conf")

#
# Set master.cf
#

locals = {
    :dovecot => dovecot_path
}
render(
    :file   => "#{dist}postfix/master.cf.erb",
    :to     => "#{etc_postfix}/master.cf",
    :mode   => 0555,
    :locals => locals
)


#
# Set main.cf
#
locals = {
    :root_path    => etc_postfix
    :dovecot      => dovecot_path,
    :adapter      => adapter,
    :mail_name    => mail_name,
    :myhostname   => myhostname,
    :mydomain     => mydomain,
    :smtpd_banner => smtpd_banner,
    :message_size_limit => message_size_limit
}
render(
    :file   => "#{dist}postfix/main.cf.erb",
    :to     => "#{etc_postfix}/main.cf",
    :mode   => 0555,
    :locals => locals
)


edit :file => "#{etc_postfix}/main.cf" do
  uncomment('reject_rbl_client bl.spamcop.net')
  uncomment('reject_rbl_client zen.spamhaus.org')
end


#
# Set DKIM
#
edit :file => "#{etc_postfix}/main.cf" do
  append 'smtpd_milters = inet:127.0.0.1:8891'
  append 'non_smtpd_milters = inet:127.0.0.1:8891'
  append 'milter_protocol = 6'
  append 'milter_default_action = accept'
end

edit :file => "/etc/default/opendkim" do
  comment /^SOCKET/
  append 'SOCKET="inet:8891@localhost"'
end

edit :file => "/etc/opendkim.conf" do
  append "KeyTable \t/etc/opendkim/KeyTable"
  append "SigningTable \t/etc/opendkim/SigningTable"
  append "ExternalIgnoreList \t/etc/opendkim/TrustedHosts"
  append "InternalHosts \t/etc/opendkim/TrustedHosts"
end

mkdir("/etc/opendkim")
mkdir_p("/var/keys/dkim")

# generate "default" key
generate_dkim_key_for_domain lookup('postfix#mydomain'), 'default'

edit :file => "/etc/opendkim/SigningTable" do

end
edit :file => "/etc/opendkim/TrustedHosts" do
  append("127.0.0.1\nlocalhost")
end


def generate_dkim_key_for_domain(domain, keyname=domain)
  sh("opendkim-genkey -r -d #{keyname} -D /var/keys/dkim")
  chown 'opendkim', 'opendkim', "/var/keys/dkim/#{keyname}.private"
  edit :file => '/etc/opendkim/KeyTable' do
    append("default._domainkey.#{keyname} #{domain}:default:/var/keys/dkim/#{keyname}.private")
  end
  edit :file => "/etc/opendkim/SigningTable" do
    append("#{domain} default._domainkey.#{keyname}")
  end
end

