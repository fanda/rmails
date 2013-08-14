def generate_dkim_key(domain, selector='default')
    sh "opendkim-genkey -r -s #{selector} -d #{domain} -D /etc/ssl/dkim"
    chown 'opendkim', 'opendkim', "/etc/ssl/dkim/#{selector}.private"
    chperm "/etc/ssl/dkim/#{selector}.txt",
           :user => 'opendkim', :group => 'rmails', :mode => 0660

    # correct bad dns record
    edit "/etc/ssl/dkim/#{selector}.txt" do
      replace ';=rsa;', ";k=rsa;"
    end

    key_table = "#{selector}._domainkey.#{domain} #{domain}:#{selector}:/etc/ssl/dkim/#{selector}.private"
    signing_table = "*@#{domain} #{selector}._domainkey.#{domain}"

    return key_table, signing_table
end
