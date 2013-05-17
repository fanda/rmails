if tagged?("ubuntu | debian")
  etc_postfix = '/etc/postfix'
  dovecot_path = '/usr/lib/dovecot/deliver'
elsif tagged?('fedora | centos')
  etc_postfix = '/etc/postfix'
  dovecot_path = '/usr/lib/dovecot/deliver'
end

adapter = lookup('postfix#database#adapter')
shell_manager.mkdir "#{etc_postfix}/#{adapter}"


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
    :mode   => 0660,
    :locals => locals
  )
end
shell_manager.chown_R('root', 'postfix', "#{etc_postfix}/#{adapter}")

#
# Set master.cf
#

locals = {
    :dovecot => dovecot_path
}
render(
    :file   => "#{dist}postfix/master.cf.erb",
    :to     => "#{etc_postfix}/master.cf",
    :mode   => 0660,
    :locals => locals
)


#
# Set main.cf
#
locals = {
    :root_path    => etc_postfix,
    :dovecot      => dovecot_path,
    :adapter      => adapter,
    :mail_name    => lookup("postfix#mail_name"),
    :myhostname   => lookup("postfix#myhostname"),
    :mydomain     => lookup("postfix#mydomain"),
    :smtpd_banner => lookup("postfix#smtpd_banner"),
    :message_size_limit => lookup("postfix#message_size_limit")
}
render(
    :file   => "#{dist}postfix/main.cf.erb",
    :to     => "#{etc_postfix}/main.cf",
    :mode   => 0660,
    :locals => locals
)


#openssl s_client -connect localhost:25 -starttls smtp -CApath /etc/ssl/certs
#unless File.file?('/etc/ssl/certs/smtpd.pem')
  generate_smtpd_key lookup("postfix#myhostname")
#end


=begin
edit :file => "#{etc_postfix}/main.cf" do
  uncomment('reject_rbl_client bl.spamcop.net')
  uncomment('reject_rbl_client zen.spamhaus.org')
end
=end

locals = {
    :mailname  => lookup("postfix#mydomain")
}
render(
    :file   => "#{dist}postfix/mailname.erb",
    :to     => "/etc/mailname",
    :mode   => 0660,
    :locals => locals
)

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


mkdir "/etc/opendkim"
mkdir_p "/etc/ssl/dkim"

edit :file => "/etc/opendkim.conf" do
  append "KeyTable \t/etc/opendkim/KeyTable"
  append "SigningTable \t/etc/opendkim/SigningTable"
  append "ExternalIgnoreList \t/etc/opendkim/TrustedHosts"
  append "InternalHosts \t/etc/opendkim/TrustedHosts"
end

# generate "default" key
key_table, signing_table = generate_dkim_key lookup('postfix#mydomain')

render :to => '/etc/opendkim/KeyTable',     :text => key_table
render :to => "/etc/opendkim/SigningTable", :text => signing_table
render :to => "/etc/opendkim/TrustedHosts", :text => "127.0.0.1\nlocalhost"


service_manager.start("postfix")
service_manager.start("opendkim")

