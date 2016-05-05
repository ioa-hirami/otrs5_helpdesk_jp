FROM centos:centos7
MAINTAINER Tomohisa Hirami<hirami@io-architect.com>

RUN yum install -y httpd-2.2.15-47 rsyslog cronie crontabs cronie-anacron

RUN yum install -y epel-release && \
    yum install -y supervisor

RUN cp /usr/share/zoneinfo/Japan /etc/localtime

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

RUN curl -o /otrs-5.0.9-01.noarch.rpm http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-5.0.9-01.noarch.rpm
#COPY otrs-5.0.9-01.noarch.rpm /

RUN yum install -y otrs-5.0.9-01.noarch.rpm

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

COPY ZZZAuto.pm /opt/otrs/Kernel/Config/Files/
COPY ZZZAAuto.pm /opt/otrs/Kernel/Config/Files/
RUN chown otrs.apache /opt/otrs/Kernel/Config/Files/ZZZAuto.pm
RUN chown otrs.apache /opt/otrs/Kernel/Config/Files/ZZZAAuto.pm


COPY otrs.sh /
RUN chmod 755 /otrs.sh

EXPOSE 80
CMD ["/otrs.sh"]
