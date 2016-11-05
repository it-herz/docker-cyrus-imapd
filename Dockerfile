FROM debian:latest

MAINTAINER Dmitrii Zolotov <dzolotov@herzen.spb.ru>

ADD imapd.conf /etc/

RUN cd /opt && apt update -y && apt install -y wget autoconf libtool pkg-config libdb5.3++-dev libssl-dev libsasl2-dev libldap2-dev libmysql++-dev libpcre++-dev libjansson-dev libevent-dev make && \
    wget ftp://ftp.cyrusimap.org/cyrus-imapd/cyrus-imapd-2.5.10.tar.gz && tar xzvpf cyrus* && rm *.tar.gz && cd cyrus* && \
    autoreconf -vi && ./configure --enable-autocreate --enable-idled --enable-event-notifications --with-mysql --with-ldap --with-cyrus-user=cyrus --with-cyrus-group=mail --with-cyrus-prefix=/ --with-service-path=/usr/sbin && \
    make && make install && useradd -g mail cyrus && mkdir -p /var/lib/cyrus && chown cyrus -R /var/lib/cyrus && mkdir -p /var/mail && chown cyrus -R /var/mail && \
    mkdir -p /var/spool/cyrus/news && mkdir -p /var/spool/news && chown cyrus -R /var/spool/cyrus/news && chown cyrus -R /var/spool/news && mkdir -p /var/spool/sieve && chown cyrus -R /var/spool/sieve && \
    cp /opt/cyrus*/master/conf/normal.conf /etc/cyrus.conf && /opt/cyrus*/tools/mkimap

EXPOSE 110 143 993 995 4190

VOLUME /var/run/cyrus/socket

ENTRYPOINT /usr/sbin/master
