
etc_nginx = '/etc/nginx'

if tagged?('debian|ubuntu')
  sites_available = 'sites-available'
  sites_enabled = 'sites-enabled'
end


site_path = "#{etc_nginx}/#{sites_available}/rmails"
locals = {
    :hostnames => lookup('hostname')
}
render(
    :file   => "#{dist}nginx/rmails.erb",
    :to     => site_path,
    :mode   => 0664,
    :locals => locals
)
shell_manager.chown('root', 'rmails', site_path)
# make path for access.log
shell_manager.mkdir_p "/var/log/nginx/#{lookup('hostname')}"


unless File.symlink? "#{etc_nginx}/#{sites_enabled}/0_rmails"
  shell_manager.ln_s  "#{etc_nginx}/#{sites_available}/rmails",
                      "#{etc_nginx}/#{sites_enabled}/0_rmails"
end

