
etc_amavis = '/etc/amavis'

locals = {
  :mydomain => lookup('postfix#mydomain')
}
render(
    :file   => "#{dist}amavis/user.erb",
    :to     => "#{etc_amavis}/conf.d/50-user",
    :mode   => 0660,
    :owner  => 'root',
    :group  => 'rmails',
    :locals => locals
)


