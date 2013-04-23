class CertificateManager

  attr_reader :interpreter

  def self.save_all_and_restart
    sm = CertificateManager.new
    sm.send 'smtpd_cert_gen', {}
  end

  def initialize
    @i = @interpreter = AutomateIt.new
  end

  def smtpd_cert_gen(params)
    #pass = SecureRandom.base64(25)
    #@i.edit :file => pass_file = @i.mktemp do
    #  append pass
    #end
    params[:email] ||= 'fandisek@rmails.com' # Property.find_by_key('postmaster').value
    @i.shell_manager.sh "openssl req -new -newkey rsa:4096 -x509 -days 3650 -nodes -out /etc/ssl/certs/smtpd.pem -keyout /etc/ssl/private/smtpd.pem -subj /C=#{params[:country]}/ST=#{params[:state]}/L=#{params[:locality]}/O=#{params[:org]}/OU=#{params[:org_unit]}/CN=#{params[:name]||Property.find_by_key('myhostname').value}/emailAddress=#{params[:email]}"
    #@i.shell_manager.rm pass_file
    #pass
  end

  def https_cert_gen(params)
    params[:email] ||= 'fandisek@rmails.com'
    @i.shell_manager.sh "openssl req -new -newkey rsa:4096 -x509 -days 3650 -nodes -out /etc/ssl/certs/https.pem -keyout /etc/ssl/private/https.pem -subj /C=/ST=/L=/O=/OU=/CN=#{params[:name]||Property.find_by_key('mydomain').value}/emailAddress=#{params[:email]}"
  end

  def dkim_cert_gen(domain, keyname=domain)
    @i.shell_manager.sh("opendkim-genkey -r -d #{keyname} -D /etc/ssl/dkim")
    @i.shell_manager.chown 'opendkim', 'opendkim', "/etc/ssl/dkim/#{keyname}.private"

    key_table = "default._domainkey.#{keyname} #{domain}:default:/etc/ssl/dkim/#{keyname}.private"
    signing_table = "#{domain} default._domainkey.#{keyname}"

    @i.edit :file => '/etc/opendkim/KeyTable' do
      append key_table
    end
    @i.edit :file => '/etc/opendkim/SigningTable' do
      append signing_table
    end
  end


end
