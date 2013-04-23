
etc_sa = '/etc/spamassassin'



locals = {
  :hostname => lookup('postfix#myhostname')
}
render(
    :file   => "#{dist}amavis/spamassassin.cf.erb",
    :to     => "#{etc_sa}/local.cf",
    :mode   => 0660,
    :owner  => 'root',
    :group  => 'rmails',
    :locals => locals
)

if tagged?('ubuntu')
  edit "/etc/default/spamassassin" do
    replace /^ENABLED\s*=\s*0\s*$/, 'ENABLED=1'
  end
end
