def generate_smtpd_key(domain)
  #pass = passwords.first||SecureRandom.base64(56)
  #edit :file => pass_file = mktemp do
  #  append pass
  #end

  # create cert. request
  #sh "openssl req -new -key #{key} -out smtpd.csr -passin file:#{pass_file} -subj /C=/ST=/L=/O=/OU=/CN=#{domain}/emailAddress="
  # create a self signed key
  #sh "openssl x509 -req -days 365 -in smtpd.csr -signkey #{key} -out /etc/ssl/certs/smtpd.pem -passin file:#{pass_file}"
  # remove the password from the private certificate
  #sh "openssl rsa -in #{key} -out /etc/ssl/private/smtpd.pem -passin file:#{pass_file}"

  sh "openssl req -new -newkey rsa:4096 -x509 -days 3650 -nodes -out /etc/ssl/certs/smtpd.pem -keyout /etc/ssl/private/smtpd.pem -subj /C=/ST=/L=/O=/OU=/CN=#{domain}/emailAddress=#{lookup('dovecot#postmaster')}"

  chperm '/etc/ssl/private/smtpd.pem',
      :user => "root",
      :group => 'rmails',
      :mode => 400
  chperm '/etc/ssl/certs/smtpd.pem',
      :user => "root",
      :group => 'rmails',
      :mode => 400

  #rm pass_file
  #pass = SecureRandom.base64(56)
  #edit :file => pass_file = mktemp do
  #  append pass
  #end
  # make ourself a trusted CA
  #sh "openssl req -new -newkey rsa:4096 -x509 -extensions v3_ca -keyout /etc/ssl/private/cakey.pem -out /etc/ssl/certs/cacert.pem -days 3650 -passin file:#{pass_file} -subj /C=/ST=/L=/O=/OU=/CN=#{domain}/emailAddress"

#  rm pass_file

  #chmod 400, '/etc/ssl/private/cakey.pem'
  #chmod 400, '/etc/ssl/certs/cacert.pem'

  #passwords << pass
end
