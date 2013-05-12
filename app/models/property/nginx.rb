class Property::Nginx < Property

  def self.service; NGINX ;end

  default_scope where(:service => self.service)

  def self.render_rmails_site_template(a, site, key_value_string)
    # example key_value_string= 'hostnames=rmails.com www.rmails.com;a=b;c=d'
    locals = Hash[ key_value_string.split(';').map  {|it|  it.split('=', 2)  } ]
    site_path = "#{etc_nginx}/#{sites_available}/#{site}"
    render(
      :file   => "#{dist}nginx/rmails.erb",
      :to     => site_path,
      :mode   => 0664,
      :locals => {:rails_root => Rails.root}.merge(locals)
    )
  end

  def site_power(a, site, run)
    site_enabled = "#{etc_nginx}/#{sites_enabled}/#{site}"
    if run
      unless File.file? site_enabled
        a.shell_manager.ln_s  "#{etc_nginx}/#{sites_available}/#{site}",
                              site_enabled
      end
    else
      a.shell_manager.rm site_enabled
    end
  end

protected

  def self.etc_nginx
    '/etc/nginx'
  end

  def self.sites_enabled
    'sites-enabled'
  end

  def self.sites_available
    'sites-available'
  end



end
