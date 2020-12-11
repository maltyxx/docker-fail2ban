#!/bin/sh

TZ=${TZ:-UTC}

F2B_LOG_LEVEL=${F2B_LOG_LEVEL:-INFO}
F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE:-1d}
F2B_IGNORE_SELF=${F2B_IGNORE_SELF:-true}
F2B_IGNORE_IP=${F2B_IGNORE_IP:-127.0.0.1/8 ::1}
F2B_BAN_TIME=${F2B_BAN_TIME:-10m}
F2B_FIND_TIME=${F2B_FIND_TIME:-10m}
F2B_MAX_RETRY=${F2B_MAX_RETRY:-5}
F2B_DEST_EMAIL=${F2B_DEST_EMAIL:-root@localhost}
F2B_SENDER=${F2B_SENDER:-root@$(hostname -f)}
F2B_ACTION=${F2B_ACTION:-%(action_)s}
F2B_IPTABLES_CHAIN=${F2B_IPTABLES_CHAIN:-INPUT}

SSMTP_PORT=${SSMTP_PORT:-25}
SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-$(hostname -f)}
SSMTP_TLS=${SSMTP_TLS:-NO}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# SSMTP
echo "Setting SSMTP configuration..."
if [ -z "$SSMTP_HOST" ] ; then
  echo "WARNING: SSMTP_HOST must be defined if you want fail2ban to send emails"
else
  cat > /etc/ssmtp/ssmtp.conf <<EOL
mailhub=${SSMTP_HOST}:${SSMTP_PORT}
hostname=${SSMTP_HOSTNAME}
FromLineOverride=YES
AuthUser=${SSMTP_USER}
AuthPass=${SSMTP_PASSWORD}
UseTLS=${SSMTP_TLS}
UseSTARTTLS=${SSMTP_TLS}
EOL
fi
unset SSMTP_HOST
unset SSMTP_USER
unset SSMTP_PASSWORD

# Fail2ban conf
echo "Setting Fail2ban configuration..."
cat > /etc/fail2ban/fail2ban.local <<EOL
[Definition]
loglevel = ${F2B_LOG_LEVEL}
logtarget = STDOUT
dbpurgeage  = ${F2B_DB_PURGE_AGE}
EOL

cat > /etc/fail2ban/action.d/iptables-common.local <<EOL
[Init]
chain = ${F2B_IPTABLES_CHAIN}
EOL

cat > /etc/fail2ban/jail.local <<EOL
[DEFAULT]
ignoreself = ${F2B_IGNORE_SELF}
ignoreip = ${F2B_IGNORE_IP}
bantime = ${F2B_BAN_TIME}
findtime = ${F2B_FIND_TIME}
maxretry = ${F2B_MAX_RETRY}
destemail = ${F2B_DEST_EMAIL}
sender = ${F2B_SENDER}
action = ${F2B_ACTION}
EOL

# Add all script
if [ -d /entrypoint.d ]; then
    for f in /entrypoint.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

exec "$@"
