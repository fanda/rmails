# Find Dovecot configuration file location using:
# `doveconf -n | head -1`

# set config file path
if tagged?("ubuntu | debian")
  etc_dovecot = '/etc/dovecot'
elsif tagged?('fedora | centos')
  etc_dovecot = '/etc/dovecot'
end

# lookup account variables
user_group_name = 'mail'
user_group_id   = 8
home = "/var/mail"
shell_manager.mkdir home

# create account for dovecot
account_manager.add_group(user_group_name, :gid => user_group_id)
account_manager.add_user(user_group_name, {
  :home   => home,
  :groups => [ user_group_name ],
  :uid    =>  user_group_id
})
# grant dovecot's home
#shell_manager.chmod('u+w', home)
#shell_manager.chown_R(user_group_name, user_group_name, home)

# create config file for SQL connection with Postfix user
locals = {
    :name     => lookup('postfix#database#name'),
    :user     => lookup('postfix#database#user'),
    :host     => lookup('postfix#database#host'),
    :adapter  => lookup('postfix#database#adapter'),
    :password => lookup('postfix#database#password')
}
render(
    :file   => "#{dist}dovecot/dovecot-sql.conf.ext.erb",
    :to     => "#{etc_dovecot}/dovecot-sql.conf.ext",
    :mode   => 0400,
    :locals => locals
)
# set read access while there is the password
shell_manager.chown('mail', 'root', "#{etc_dovecot}/dovecot-sql.conf.ext")
#shell_manager.chmod('go=', "#{etc_dovecot}/dovecot-sql.conf.ext")

# create config file for dovecot service
locals = {
  :protocols  => lookup('dovecot#protocols'),
  :gid        => user_group_id,
  :home       => home,
  :postmaster => lookup('dovecot#postmaster'),
  :storage    => {
    :size  => lookup('dovecot#storage_size'),
    :spam  => lookup('dovecot#spam_storage_size'),
    :trash => lookup('dovecot#trash_storage_size')
  },
  :auth_verbose => 'yes'
}
render(
    :file   => "#{dist}dovecot/dovecot.conf.erb",
    :to     => "#{etc_dovecot}/dovecot.conf",
    :mode   => 0660,
    :locals => locals
)
shell_manager.chown(user_group_name, 'rmails', "#{etc_dovecot}/dovecot.conf")
#shell_manager.chmod('0420', "#{etc_dovecot}/dovecot.conf")


#
# Generate new PKI
#
unless File.file?('/etc/ssl/private/dovecot.pem')
  shell_manager.sh 'openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/dovecot.pem -keyout /etc/ssl/private/dovecot.pem'
  shell_manager.chmod '0400', "/etc/ssl/certs/dovecot.pem"
  shell_manager.chmod '0400', "/etc/ssl/private/dovecot.pem"
end


