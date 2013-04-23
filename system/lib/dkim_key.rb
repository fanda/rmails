def generate_dkim_key(domain, keyname=domain)
    sh("opendkim-genkey -r -d #{keyname} -D /etc/ssl/dkim")
    chown 'opendkim', 'opendkim', "/etc/ssl/dkim/#{keyname}.private"

    key_table = "default._domainkey.#{keyname} #{domain}:default:/etc/ssl/dkim/#{keyname}.private"
    signing_table = "#{domain} default._domainkey.#{keyname}"

    return key_table, signing_table
end
