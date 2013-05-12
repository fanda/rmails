def generate_dkim_key(domain, selector='default')
    sh "opendkim-genkey -r -s #{selector} -d #{domain} -D /etc/ssl/dkim"
    chown 'opendkim', 'opendkim', "/etc/ssl/dkim/#{selector}.private"
    chown 'opendkim', 'rmails', "/etc/ssl/dkim/#{selector}.txt"
    chmod 0660, "/etc/ssl/dkim/#{selector}.txt"

    # correct bad dns record
    edit "/etc/ssl/dkim/#{selector}.txt" do
      replace ';=rsa;', ";k=rsa;"
    end

    key_table = "#{selector}._domainkey.#{domain} #{domain}:#{selector}:/etc/ssl/dkim/#{selector}.private"
    signing_table = "*@#{domain} #{selector}._domainkey.#{domain}"

    return key_table, signing_table
end
