FROM docker:18.09

LABEL maintainer="Yoann VANITOU <yvanitou@gmail.com>"

ARG FAIL2BAN_VERSION=0.10.4

RUN apk add --no-cache \
      ca-certificates \
      curl \
      ipset \
      iptables \
      ip6tables \
      python3 \
      py-setuptools \
      ssmtp \
      tzdata \
      wget \
      whois \
      py-curl \
    && cd /tmp \
    && wget https://github.com/fail2ban/fail2ban/archive/${FAIL2BAN_VERSION}.tar.gz -O fail2ban-${FAIL2BAN_VERSION}.tar.gz \
    && tar xvzf fail2ban-${FAIL2BAN_VERSION}.tar.gz \
    && cd fail2ban-${FAIL2BAN_VERSION} \
    && python setup.py install \
    && cd / \
    && mkdir -p /usr/local/etc/fail2ban \
    && cp -rp /etc/fail2ban /usr/local/etc \
    && rm -rfv /tmp/*

COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 -v /entrypoint.sh \
    && mkdir -v /entrypoint.d

VOLUME ["/etc/fail2ban", "/var/lib/fail2ban"]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["fail2ban-server", "-f", "-x", "start"]

HEALTHCHECK --interval=30s --timeout=5s CMD fail2ban-client ping || exit 1
