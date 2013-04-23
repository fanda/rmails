def server_key(file='/etc/rmails.key')
  pass = SecureRandom.base64(56)
  edit :file => pass_file = mktemp do
    append pass
  end
  puts pass+' '+pass_file
  sh "openssl genrsa -des3 -rand /etc/hosts -out #{file} 4096 -passout file:#{pass_file}"
  rm pass_file
  chperm file, :user => "root", :group => 'rmails', :mode => 400
  pass
end

def nginx_key
  sh "openssl req -new -newkey rsa:4096 -x509 -days 3650 -nodes -out /etc/ssl/certs/https.pem -keyout /etc/ssl/private/https.pem -subj /C=/ST=/L=/O=/OU=/CN=#{lookup('postfix#mydomain')}/emailAddress=#{lookup('dovecot#postmaster')}"
  chperm '/etc/ssl/certs/https.pem',
      :user => "root",
      :group => 'rmails',
      :mode => 400
  chperm '/etc/ssl/private/https.pem',
      :user => "root",
      :group => 'rmails',
      :mode => 400
end
