#! /bin/bash

/usr/bin/newaliases
/usr/sbin/postfix start

echo -e "Starting Cron"
/opt/otrs/bin/Cron.sh start otrs

echo -e "Starting supervisord.."
/bin/supervisord -c /etc/supervisord.conf
