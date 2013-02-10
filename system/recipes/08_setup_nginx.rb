etc_nginx = '/etc/nginx'

shell_manager.sh 'passenger-install-nginx-module'

locals = {
    :hostname => lookup('hostname'),
    :prefer_www => lookup('web#prefer_www')
}
render(
    :file   => "#{dist}nginx/rails.erb",
    :to     => "#{etc_nginx}/sites-available/rails",
    :locals => locals
)
shell_manager.ln_s "#{etc_nginx}/sites-available/rails",
                   "#{etc_nginx}/sites-enabled/0_rails"


