#! /bin/bash

echo -e "Starting Cron"
/opt/otrs/bin/Cron.sh start otrs

echo -e "Starting supervisord.."
/bin/supervisord -c /etc/supervisord.conf
