etc_awstats   = '/etc/awstats'
log_awstats   = '/var/log/mail.log'
awstats_tools = '/usr/share/awstats/tools'
awstats_out   = '/var/lib/awstats/outputs'
bin = '/usr/bin'

render(
    :file   => "#{dist}awstats/prepflog.pl",
    :to     => "#{bin}/prepflog.pl",
    :mode   => 400,
    :owner  => 'root',
    :group  => 'rmails'
)
unless File.symlink?("#{bin}/maillogconvert.pl")
  shell_manager.ln_s "#{awstats_tools}/maillogconvert.pl", "#{bin}/maillogconvert.pl"
end
unless File.symlink?("#{bin}/awstats_buildstaticpages.pl")
  shell_manager.ln_s "#{awstats_tools}/awstats_buildstaticpages.pl", "#{bin}/awstats_buildstaticpages.pl"
end

locals = {
    :logfile => log_awstats,
    :domain  => lookup('hostname'),
    :outputs => awstats_out

}
render(
    :file   => "#{dist}awstats/awstats.mail.conf.erb",
    :to     => "#{etc_awstats}/awstats.mail.conf",
    :locals => locals,
    :mode   => 400,
    :owner  => 'root',
    :group  => 'rmails'
)




#shell_manager.chmod '400', "#{etc_awstats}/*.conf"

#sudo /usr/local/awstats/tools/awstats_buildstaticpages.pl -update -config=www.example.com -dir=/home/demo/public_html/example.com/public/webstats -awstatsprog=/usr/local/awstats/wwwroot/cgi-bin/awstats.pl

#shell_manager.sh "(crontab -l; echo '00 1 * * * /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -update -config=mail') | crontab -"

#shell_manager.sh "(crontab -l; echo '00 1 * * * /usr/bin/perl #{bin}/awstats_buildstaticpages.pl -update -config=mail' -dir=/var/www/mailstats -awstatsprog=/usr/lib/cgi-bin/awstats.pl) | crontab -"


shell_manager.sh "(echo '00 1 * * * /usr/bin/perl #{bin}/awstats_buildstaticpages.pl -update -config=mail -dir=/var/www/mailstats -awstatsprog=/usr/lib/cgi-bin/awstats.pl
00 1 * * * /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -update -config=mail') | crontab -"
