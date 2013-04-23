
etc_dspam = '/etc/dspam'


locals = {
  :database_port => lookup('database#port'),
  :database_user => lookup('dspam#database#user'),
  :database_pass => lookup('dspam#database#password'),
  :database => lookup('dspam#database#name'),
  :hostname => lookup('postfix#myhostname')
}
render(
    :file   => "#{dist}dspam/conf.erb",
    :to     => "#{etc_dspam}/dspam.conf",
    :mode   => 0660,
    :locals => locals
)
shell_manager.chown('root', 'rmails', "#{etc_dspam}/dspam.conf")


shell_manager.chown_R('dspam', 'www', "/var/spool/dspam")
#shell_manager.chmod_R('4555', "/var/spool/dspam")


