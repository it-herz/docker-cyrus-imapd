#!/bin/bash
mkdir -p /var/run/cyrus
mkdir -p /var/imap/db
chmod 777 -R /var/run/cyrus/*
chown cyrus -R /var/run/cyrus
chmod 777 -R /var/run/saslauthd
chmod 777 -R /var/imap
/usr/sbin/master
