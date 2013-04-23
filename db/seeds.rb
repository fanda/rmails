#a = AdminUser.create({:email=>'fandisek@gmail.com', :password => 'hesloo11', :password_confirmation => 'hesloo11'})

#a.virtual_domains.create({:name => 'rmails.com'})

Property.add :dovecot,      'disable_plaintext_auth',              'yes', 'yes_no'
Property.add :dovecot,      'auth_username_chars',                 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_@', 'value+param_string'
Property.add :dovecot,      'auth_worker_max_count',               '30', 'value+number'
Property.add :dovecot,      'auth_verbose',                        'no', 'yes_no'
Property.add :dovecot,      'mail_cache_min_mail_count',           '0', 'value+number'
Property.add :dovecot,      'imap_login__listener__port',          '143', 'commented_value+number'
Property.add :dovecot,      'imaps_login__listener__port',         '993', 'commented_value+number'
Property.add :dovecot,      'pop3_login_listener_port',            '110', 'commented_value+number'
Property.add :dovecot,      'pop3s_login__listener__port',         '995', 'commented_value+number'
Property.add :dovecot,      'imap__process_limit',                 '1024', 'commented_value+number'
Property.add :dovecot,      'pop3__process_limit',                 '1024', 'commented_value+number'
Property.add :dovecot,      'quota_full_tempfail',                 'no', 'yes_no'
Property.add :dovecot,      'rejection_subject',                   'Rejected: %s', 'value+param_string'
Property.add :dovecot,      'rejection_reason',                    'Your message to %t was automatically rejected:%n%r', 'value+param_string'
Property.add :dovecot,      'storage_size',                        '400M', 'storage+mega_size'
Property.add :dovecot,      'storage_trash',                       '10%', 'storage+percent'
Property.add :dovecot,      'storage_spam',                        '10%', 'storage+percent'

Property.add :postfix,      'message_size_limit',                  '15728640', 'main_value+number'
Property.add :postfix,      'mail_name',                           'Rmails', 'main_value+string'
Property.add :postfix,      'myhostname',                          'rmails.com', 'main_value+string'
Property.add :postfix,      'mydomain',                            'rmails.com', 'main_value+string'
Property.add :postfix,      'smtpd_banner',                        "$myhostname ESMTP $mail_name", 'main_value+string'
Property.add :postfix,      'mynetworks',                          '192.168.0.0/16 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128', 'main_value+string'
Property.add :postfix,      'reject_rbls',                         '+bl.spamcop.net;+dnsbl.sorbs.net;+zen.spamhaus.org', 'rbl_client+multiselect_from_list'

Property.add :nginx,        'site:app',                            'hostnames=rmails.com www.rmails.com', 'render_thin_site+key_value'

Property.add :dspam,        'enableBNR',                           'on', 'on_off_pref+on_off'
Property.add :dspam,        'enableWhitelist',                     'on', 'on_off_pref+on_off'
Property.add :dspam,        'whitelistThreshold',                  '10', 'preference+number'
Property.add :dspam,        'statisticalSedation',                 '5', 'preference+number'
Property.add :dspam,        'spamSubject',                         '[SPAM]', 'preference+string'
Property.add :dspam,        'spamAction',                          'quarantine;deliver;+tag', 'enum+select_from_enum'
Property.add :dspam,        'signatureLocation',                   '+headers;message', 'enum+select_from_enum'


Property.add :rmails,       'smtpd_cert',                          '', 'cert'
Property.add :rmails,       'https_cert',                          '', 'cert'
Property.add :rmails,       'dkim_cert',                           '', 'cert'

