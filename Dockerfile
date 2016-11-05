FROM debian:latest

MAINTAINER Dmitrii Zolotov <dzolotov@herzen.spb.ru>

ADD imapd.conf /etc/

RUN cd /opt && apt update -y && apt install -y wget autoconf libtool pkg-config libdb5.3++-dev libssl-dev libsasl2-dev libldap2-dev libmysql++-dev libpcre++-dev libjansson-dev libevent-dev make sasl2-bin && \
    wget ftp://ftp.cyrusimap.org/cyrus-imapd/cyrus-imapd-2.5.10.tar.gz && tar xzvpf cyrus* && rm *.tar.gz && cd cyrus* && \
    autoreconf -vi && ./configure --enable-autocreate --enable-idled --enable-gssapi --enable-event-notifications --with-mysql --with-ldap --with-cyrus-user=cyrus --with-cyrus-group=mail --with-cyrus-prefix=/ --with-service-path=/usr/sbin && \
    make && make install && useradd -g mail cyrus && mkdir -p /var/imap/socket && chmod 777 /var/imap/socket && mkdir -p /var/run/cyrus/proc && chmod 777 -R /var/run/cyrus/proc && \
    mkdir -p /var/lib/cyrus && chown cyrus -R /var/lib/cyrus && mkdir -p /var/imap/db && chmod 777 -R /var/imap/db && mkdir -p /var/mail && chown cyrus -R /var/mail && \
    mkdir -p /var/spool/cyrus/news && mkdir -p /var/spool/news && chown cyrus -R /var/spool/cyrus/news && chown cyrus -R /var/spool/news && mkdir -p /var/spool/sieve && chown cyrus -R /var/spool/sieve && \
    cp /opt/cyrus*/master/conf/normal.conf /etc/cyrus.conf && /opt/cyrus*/tools/mkimap && ldconfig

ADD permissions.sh /opt/permissions.sh

RUN chmod +x /opt/permissions.sh && apt install -y uuid-dev libgcrypt-dev libestr-dev flex dh-autoreconf bison python-docutils libxml2-dev git python-setuptools re2c && \
    cd /opt && git clone https://github.com/rsyslog/libfastjson && cd libfastjson && autoreconf -v --install && ./configure && make && make install && \
    git clone https://github.com/rsyslog/liblogging && cd liblogging && autoreconf -v --install && ./configure --disable-man-pages && make && make install && \
    git clone https://github.com/rsyslog/rsyslog && cd rsyslog && ./autogen.sh --enable-omstdout && make && make install && ldconfig && \
    mkdir /var/log/supervisor/ && /usr/bin/easy_install supervisor && /usr/bin/easy_install supervisor-stdout

EXPOSE 110 143 993 995 4190

ADD supervisord.conf /etc/supervisord.conf
ADD rsyslog.conf /etc/rsyslog.conf

CMD ["supervisord","-n","-c","/etc/supervisord.conf"]
