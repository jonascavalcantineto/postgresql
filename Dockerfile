FROM postgres:9.6
LABEL MAINTAINER="Jonas Cavalcanti <jonascavalcantineto@gmail.com>"


RUN apt-get update -y
RUN apt-get install -y vim \
                telnet \
            	wget \
				supervisor \
                postgresql-contrib-9.6

ENV TZ=America/Fortaleza
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DB_ENV="PROD"
ENV PGSQL_VERSION="9.6"

ADD scripts/retention-control /usr/local/sbin
ADD scripts/pgsql-db-backup /usr/local/sbin

ADD confs/postgresql.conf /tmp/

RUN chmod 755 /usr/local/sbin -R

ADD confs/supervisord.conf /etc/supervisord.conf

ADD confs/start-postgresql.sh /start-postgresql.sh
RUN chmod +x /start-postgresql.sh

ADD confs/start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /var/lib/postgresql/data

CMD ["/start.sh"]