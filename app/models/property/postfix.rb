class Property::Postfix < Property

  def self.service; POSTFIX ;end

  default_scope where(:service => self.service)

  def self.main_value_template(a, locals)
    a.edit :file => "#{etc_postfix}/main.cf", :backup => false do
      locals.each do |key, value|
        replace /^#{key}\s*=\s*.*$/, "#{key}=#{value}"
      end
    end
  end

  # reject_rbl_client bl.spamcop.net
  # reject_rbl_client zen.spamhaus.org  ...
  # values = {'bl.spamcop.net' => true, 'zen.spamhaus.org' => false}
  def self.rbl_client_template(a, values)
    a.edit :file => "#{etc_postfix}/main.cf", :backup => false do
      values.each do |key, value|
        value ? uncomment(key) : comment(key)
      end
    end
  end

  def self.dspam_power(a, run)
    a.edit :file => "#{etc_postfix}/master.cf", :backup => false do
      if run
        uncomment 'filter=lmtp:unix:/var/run/dspam'
        uncomment 'localhost:7711 inet'
      else
        comment 'filter=lmtp:unix:/var/run/dspam'
        comment 'localhost:7711 inet'
      end
    end
  end

  def self.dkim_power(a, run)
    a.edit :file => "#{etc_postfix}/main.cf", :backup => false do
      if run
        uncomment 'smtpd_milters = inet:127.0.0.1:8891'
        uncomment 'non_smtpd_milters = inet:127.0.0.1:8891'
      else
        comment 'smtpd_milters = inet:127.0.0.1:8891'
        comment 'non_smtpd_milters = inet:127.0.0.1:8891'
      end
    end
    a.edit :file => "/etc/default/opendkim", :backup => false do
      if run
        uncomment 'SOCKET="inet:8891@localhost"'
      else
        comment 'SOCKET="inet:8891@localhost"'
      end
    end
  end

protected

  def self.etc_postfix
    '/etc/postfix'
  end


end
