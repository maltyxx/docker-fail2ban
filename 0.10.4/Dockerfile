FROM docker:18.09

MAINTAINER Yoann VANITOU <yvanitou@gmail.com>

ARG FAIL2BAN_VERSION=0.10.4

RUN apk add --no-cache \
    ca-certificates \
    curl \
    ipset \
    iptables \
    ip6tables \
    python3 \
    python3-dev \
    py-setuptools \
    ssmtp \
    tzdata \
    wget \
    whois \
  && wget -O fail2ban.tar.gz "https://github.com/fail2ban/fail2ban/archive/${FAIL2BAN_VERSION}.tar.gz" \
  && tar --extract \
		--file fail2ban.tar.gz \
		--directory /tmp \
  && cd /tmp/fail2ban-${FAIL2BAN_VERSION} \
  && python setup.py install \
  && cd / \
  && mkdir -p /usr/local/etc/fail2ban \
  && cp -rp /etc/fail2ban /usr/local/etc \
  && rm -rf /tmp/fail2ban-${FAIL2BAN_VERSION} /fail2ban.tar.gz

COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh \
  && mkdir -v /entrypoint.d

VOLUME ["/etc/fail2ban", "/var/lib/fail2ban"]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["fail2ban-server", "-f", "-x", "start"]

HEALTHCHECK --interval=30s --timeout=5s CMD fail2ban-client ping || exit 1
