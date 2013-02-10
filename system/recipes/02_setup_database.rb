
puts "?? Installed version of psql is #{`psql --version`=~/\s(\d.\d)\./;$1}"

if tagged?("ubuntu | debian")
  etc_postgresql = "/etc/postgresql/#{$1}/main"

elsif tagged?("fedora | centos")
  etc_postgresql = "/var/lib/pgsql/#{$1}/data/"

end

#edit(:file => "#{etc_postgresql}/pg_hba.conf") do
#  append("host \t all \t all \t 127.0.0.1/32 \t md5")
#end

# get password for database connection
password = lookup('postfix#database#password')

# create roles and application database
shell_manager.sh "sudo -u postgres psql << EOF\n
CREATE USER postfix ENCRYPTED password '#{password}';\n
CREATE USER dovecot ENCRYPTED password '#{password}';\n
CREATE ROLE rmails_app WITH USER postfix, dovecot;\n
CREATE DATABASE rmails OWNER rmails_app;\n
EOF"

# create database schema via ActiveRecord Migrations
shell_manager.sh "sudo -u vagrant cd /vagrant; RAILS_ENV=production rake db:migrate"

# grant privileges for postfix and dovecot roles
shell_manager.sh "sudo -u postgres psql << EOF\n
GRANT SELECT ON virtual_aliases TO dovecot;\n
GRANT SELECT ON virtual_domain,virtual_user,virtual_aliases TO postfix;\n
EOF"

