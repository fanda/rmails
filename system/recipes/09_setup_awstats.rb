etc_awstats   = '/etc/awstats'
log_awstats   = '/var/log/mail.log'
awstats_tools = '/usr/share/awstats/tools'
awstats_out   = '/var/lib/awstats/outputs'
bin = '/usr/bin'

render(
    :file   => "#{dist}awstats/prepflog.pl",
    :to     => "#{bin}/prepflog.pl",
    :locals => locals
)
#shell_manager.chmod XXX
shell_manager.ln_s "#{tools_path}/maillogconvert.pl", "#{bin}/maillogconvert.pl"


locals = {
    :logfile => log_awstats,
    :domain  => lookup('hostname'),
    :outputs => awstats_out

}
render(
    :file   => "#{dist}awstats/awstats.mail.conf.erb",
    :to     => "#{etc_awstats}/awstats.mail.conf",
    :locals => locals
)




shell_manager.chmod '400', "#{etc_awstats}/*.conf"


shell_manager.sh "(crontab -l; echo '00 1 * * * /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -update -config=mail') | crontab -"
