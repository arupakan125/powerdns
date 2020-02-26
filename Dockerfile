FROM ubuntu:bionic

COPY /pdns /etc/apt/preferences.d/pdns
COPY /docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh
RUN apt update \
    && apt install -y --no-install-recommends \
    curl \  
    gpg-agent \
    software-properties-common

RUN curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - \
    && add-apt-repository 'deb [arch=amd64] http://repo.powerdns.com/ubuntu bionic-auth-43 main' \
    && apt update \
    && apt install -y --no-install-recommends \
    pdns-server \
    pdns-backend-sqlite3 \
    sqlite3 \
    && apt -y clean \
    && rm -rf /var/lib/apt/lists/*

ENV ALLOW_AXFR_IPS 0.0.0.0/0
ENV API yes
ENV MASTER yes
ENV SLAVE yes
ENV WEBSERVER_ADDRESS 0.0.0.0
ENV WEBSERVER_ALLOW_FROM 0.0.0.0/0

STOPSIGNAL SIGKILL

EXPOSE 53 53/udp 8081


CMD ["/docker-entrypoint.sh"]