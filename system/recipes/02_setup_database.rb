service_manager.start("postgresql")

puts "?? Installed version of psql is #{`psql --version`=~/\s(\d.\d)\./;$1}"

if tagged?("ubuntu | debian")
  etc_postgresql = "/etc/postgresql/#{$1}/main/"

elsif tagged?("fedora | centos")
  etc_postgresql = "/var/lib/pgsql/#{$1}/data/"

end



locals = {
    :port   => lookup('database#port'),
    :max_connections   => lookup('database#max_connections')
}
render  :file => "#{dist}postgresql/postgresql.conf.erb",
        :to => "#{etc_postgresql}postgresql.conf",
        :user => 'postgres',
        :group => 'rmails',
        :locals => locals

edit(:file => "#{etc_postgresql}pg_hba.conf") do
  unless contains?(/^host\sall\sall\s127.0.0.1\/32\smd5$/)
    append("host \t all \t all \t 127.0.0.1/32 \t md5")
  end
end

service_manager.restart("postgresql")

# get password for database connection
password = lookup('postfix#database#password')

#if '1'==`sudo -u postgres psql -l | grep -w rmails | wc -l`.to_s.chomp
# create roles and application database
  shell_manager.sh "sudo -u postgres psql << EOF
    CREATE USER postfix ENCRYPTED password '#{password}';
    CREATE USER dovecot ENCRYPTED password '#{password}';
    CREATE ROLE rmails_app WITH USER postfix, dovecot LOGIN PASSWORD '#{password}';
    CREATE DATABASE rmails OWNER rmails_app;
EOF", :quiet => true
#end

# render rails database definition
locals = {
    :password => password,
    :dbhost   => lookup('database#host'),
    :dbport   => lookup('database#port')
}
render  :file => "#{dist}rmails/database.yml.erb",
        :to => "#{rails_root}/config/database.yml",
        :locals => locals

# create database schema via ActiveRecord Migrations
#rake_task["db:migrate"].reenable
#rake_task["db:migrate"].invoke
shell_manager.cd rails_root do
  shell_manager.sh "rake db:migrate"
  shell_manager.sh "rake db:seed"
end

# grant privileges for postfix and dovecot roles
shell_manager.sh "sudo -u postgres psql -d rmails << EOF
  GRANT SELECT ON virtual_aliases TO dovecot;
  GRANT SELECT ON virtual_domains,virtual_users,virtual_aliases TO postfix;
EOF"

