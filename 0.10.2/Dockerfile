FROM ubuntu:bionic

MAINTAINER Romain GALLIEN <r.gallien@santiane.fr>
MAINTAINER Yoann VANITOU <yvanitou@gmail.com>

ENV FAIL2BAN_VERSION 0.10.2

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install fail2ban="$FAIL2BAN_VERSION*" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./etc/fail2ban.conf /etc/fail2ban/fail2ban.conf
RUN chmod -v 644 /etc/fail2ban/fail2ban.conf

RUN mkdir -v /var/run/fail2ban

VOLUME ["/var/lib/fail2ban"]

CMD ["fail2ban-server", "-f"]
