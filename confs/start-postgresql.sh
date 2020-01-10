#!/bin/bash


echo "SETTING PERMISSIONS"
chown postgres /var/lib/postgresql/ -R

if [ ! -f /var/lib/postgresql/data/postgresql.conf ]
then
    su - postgres -c "/usr/lib/postgresql/${PGSQL_VERSION}/bin/initdb -E UTF-8 -D /var/lib/postgresql/data/"
    
fi

if [ ${DB_ENV} == "prod" -o  ${DB_ENV} == "master" ]
then
    cp /tmp/postgresql.conf /var/lib/postgresql/data/
fi

sleep 3

su - postgres -c "/usr/lib/postgresql/${PGSQL_VERSION}/bin/pg_ctl -l /var/log/postgresql/server.log -D /var/lib/postgresql/data/ start"
if [ $? == 0 ]
then
    echo "[SUCCESS] - Start PostgreSQL!!!"
else
    echo "[ERROR] - Start PostgreSQL!!!"
fi