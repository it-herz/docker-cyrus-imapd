FROM debian:latest

MAINTAINER Dmitrii Zolotov <dzolotov@herzen.spb.ru>

RUN cd /opt && apt update -y && apt install -y wget autoconf libtool pkg-config libdb5.3++-dev libssl-dev libsasl2-dev libldap2-dev libmysql++-dev libpcre++-dev libjansson-dev libevent-dev make && \
    wget ftp://ftp.cyrusimap.org/cyrus-imapd/cyrus-imapd-2.5.10.tar.gz && tar xzvpf cyrus* && rm *.tar.gz && cd cyrus* && \
    autoreconf -vi && ./configure --enable-autocreate --enable-idled --enable-event-notifications --with-mysql --with-ldap --with-cyrus-user=cyrus --with-cyrus-group=mail --with-cyrus-prefix=/ --with-service-path=/usr/sbin && \
    make && make install && useradd -g mail cyrus && mkdir -p /var/lib/cyrus && chown cyrus -R /var/lib/cyrus && mkdir -p /var/spool/cyrus/mail && chown cyrus -R /var/spool/cyrus && \
    mkdir -p /var/spool/cyrus/news && mkdir -p /var/spool/news && chown cyrus -R /var/spool/cyrus/news && chown cyrus -R /var/spool/news && mkdir -p /var/spool/sieve && chown cyrus -R /var/spool/sieve

ADD cyrus.conf /etc/
ADD imapd.conf /etc/
