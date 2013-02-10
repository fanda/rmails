

# mkdir -p /etc/ssl/dovecot
# cd /etc/ssl/dovecot
# openssl req -new -x509 -nodes -out cert.pem -keyout key.pem -days 365
# chmod 640 /etc/ssl/dovecot/*

# mkdir -p /etc/ssl/mycompany/mailserver/
 # cd /etc/ssl/mycompany/mailserver/
 # openssl genrsa 1024 > mail-key.pem
 # chmod 400 mail-key.pem
 # openssl req -new -x509 -nodes -sha1 -days 365 -key mail-key.pem > mail-cert.pem
