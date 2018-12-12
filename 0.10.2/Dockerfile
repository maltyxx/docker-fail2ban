FROM ubuntu:18.04

MAINTAINER Yoann VANITOU <yvanitou@gmail.com>

ENV FAIL2BAN_VERSION 0.10.2

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install fail2ban="$FAIL2BAN_VERSION*" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./config/* /etc/fail2ban/
RUN chmod -v 644 /etc/fail2ban/fail2ban.local /etc/fail2ban/jail.local

RUN mkdir -v /var/run/fail2ban

VOLUME ["/var/lib/fail2ban", "/etc/fail2ban"]

CMD ["fail2ban-server", "-f"]
