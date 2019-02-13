#!/bin/sh -eu

sudo -u postgres /usr/pgsql-10/bin/initdb -D /var/lib/pgsql/10/data/
sudo -u postgres /usr/pgsql-10/bin/pg_ctl -D /var/lib/pgsql/10/data/ start

echo "create database test;" | sudo -u postgres psql
echo "create user test with encrypted password 'test';" | sudo -u postgres psql
echo "grant all privileges on database test to test;" | sudo -u postgres psql
