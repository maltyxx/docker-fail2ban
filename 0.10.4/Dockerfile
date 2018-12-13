FROM alpine:3.8

MAINTAINER Yoann VANITOU <yvanitou@gmail.com>

ARG FAIL2BAN_VERSION=0.10.4

RUN apk --update --no-cache add \
    ca-certificates curl ipset iptables ip6tables python3 python3-dev py-setuptools ssmtp tzdata wget whois \
  && cd /tmp \
  && curl -SsOL https://github.com/fail2ban/fail2ban/archive/${FAIL2BAN_VERSION}.zip \
  && unzip ${FAIL2BAN_VERSION}.zip \
  && cd fail2ban-${FAIL2BAN_VERSION} \
  && python setup.py install \
  && mkdir /etc/old
  && cp -rp /etc/fail2ban /etc/old/
  && rm -rf /var/cache/apk/* /tmp/*

COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

VOLUME ["/etc/fail2ban", "/var/lib/fail2ban"]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["fail2ban-server", "-f", "-x", "start"]

HEALTHCHECK --interval=10s --timeout=5s CMD fail2ban-client ping || exit 1
