FROM centos:centos7
MAINTAINER Tomohisa Hirami<hirami@io-architect.com>


RUN yum install -y httpd rsyslog cronie crontabs cronie-anacron

RUN yum install -y epel-release && \
    yum install -y supervisor

RUN cp /usr/share/zoneinfo/Japan /etc/localtime
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

COPY mysql57-community-release-el7-8.noarch.rpm /
RUN yum install -y mysql57-community-release-el7-8.noarch.rpm
RUN yum install -y mysql-community-server
COPY my.cnf /etc/

RUN yum install -y "perl(Crypt::Eksblowfish::Bcrypt)" && \
    yum install -y "perl(DBD::mysql)" && \
    yum install -y "perl(JSON::XS)" && \
    yum install -y "perl(Mail::IMAPClient)" && \
    yum install -y "perl(ModPerl::Util)" && \
    yum install -y "perl(Text::CSV_XS)" && \
    yum install -y "perl(YAML::XS)"

RUN curl -o /otrs-5.0.20-01.noarch.rpm http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-5.0.20-01.noarch.rpm
RUN yum install -y otrs-5.0.20-01.noarch.rpm

COPY supervisord.conf /etc/
COPY supervisord.d/httpd.ini /etc/supervisord.d/
COPY supervisord.d/rsyslogd.ini /etc/supervisord.d/
COPY supervisord.d/mysqld.ini /etc/supervisord.d/
COPY supervisord.d/crond.ini /etc/supervisord.d/

RUN mysql_install_db --datadir=/var/lib/mysql

COPY mysql_init.sh /
COPY otrs_vanilla.sql.gz /
RUN chmod 755 mysql_init.sh
RUN /mysql_init.sh

COPY Config.pm /opt/otrs/Kernel/
RUN chown otrs.apache /opt/otrs/Kernel/Config.pm

COPY ZZZAuto.pm ZZZAAuto.pm /opt/otrs/Kernel/Config/Files/
RUN chown otrs.apache /opt/otrs/Kernel/Config/Files/ZZZAuto.pm /opt/otrs/Kernel/Config/Files/ZZZAAuto.pm
RUN chmod 660 /opt/otrs/Kernel/Config/Files/ZZZAuto.pm /opt/otrs/Kernel/Config/Files/ZZZAAuto.pm


COPY otrs.sh /
RUN chmod 755 /otrs.sh

# Config Postfix
RUN yum install -y postfix
COPY main.cf /etc/postfix/

RUN useradd -m cust01 && useradd -m cust02 && useradd -m cust03 && useradd -m cust04 && useradd -m cust05
RUN echo cust01 | passwd --stdin cust01
RUN echo cust02 | passwd --stdin cust02
RUN echo cust03 | passwd --stdin cust03
RUN echo cust04 | passwd --stdin cust04
RUN echo cust05 | passwd --stdin cust05

RUN useradd -m helpdesk
RUN echo helpdesk | passwd --stdin helpdesk

RUN useradd -m agent01 && useradd -m agent02 && useradd -m agent03 && useradd -m agent04 && useradd -m agent05
RUN echo agent01 | passwd --stdin agent01
RUN echo agent02 | passwd --stdin agent02
RUN echo agent03 | passwd --stdin agent03
RUN echo agent04 | passwd --stdin agent04
RUN echo agent05 | passwd --stdin agent05

# Config Dovecot
RUN yum install -y dovecot
COPY dovecot.conf /etc/dovecot/
COPY 10-mail.conf /etc/dovecot/conf.d/
COPY supervisord.d/dovecot.ini /etc/supervisord.d/


# Squirrelmail
RUN yum install -y squirrelmail
COPY config.php /etc/squirrelmail/
RUN chown root.apache /etc/squirrelmail/config.php
COPY squirrelmail.conf /etc/httpd/conf.d/

# 日本語対応
# http://taka2.info/20120705/squirrelmail-php54/
#
RUN find /usr/share/squirrelmail -name '*.php' -print \
 | xargs egrep -l 'htmlspecialchars *\([^\)]' \
 | egrep -v 'global.php|configtest.php|login.php|class/|contrib/' \
 | xargs perl -i.bak -pe 's/htmlspecialchars *\([^\)]/sq_$&/'
COPY ext_i18n.php /
RUN cat /ext_i18n.php >> /usr/share/squirrelmail/functions/i18n.php

EXPOSE 80
CMD ["/otrs.sh"]
