#! /bin/bash

PASS=`tail -1 /root/.mysql_secret`

echo "[client]" > /root/.my.cnf
echo "password=\"$PASS\"" >> /root/.my.cnf


/usr/sbin/mysqld --pid-file=/var/run/mysqld/mysqld.pid --user=root &
sleep 20
mysqladmin password otrs-ioa

echo "[client]" > /root/.my.cnf
echo 'password="otrs-ioa"' >> /root/.my.cnf

echo "Set mysql root password to 'otrs-ioa'"

echo "Create database & user."
echo "create database otrs default character set utf8;" | mysql
echo "grant all on otrs.* to otrs@localhost identified by 'otrs-ioa';" | mysql

echo "Restore otrs database. Wait a moment..."
zcat /otrs_vanilla.sql.gz | mysql otrs
echo "Restore done."

exit 0
