# maltyxx/docker-fail2ban

## About

🐳 This is a Docker image for [Fail2ban](https://www.fail2ban.org), based on Alpine Linux.
Interested in more? [Check out](https://hub.docker.com/r/maltyxx/) my other 🐳 Docker images!

## Supported Architectures

- armv7 (arm32)
- armv8 (arm64)
- amd64 (x86_64)

## Docker

### Environment Variables

* `TZ` : The timezone set for the container (default `UTC`)
* `F2B_LOG_LEVEL` : The level of log output (default `INFO`)
* `F2B_DB_PURGE_AGE` : The age at which bans should be removed from the database (default `1d`)
* `F2B_IGNORE_SELF` : Toggles ignoring of local IP addresses (default `true`)
* `F2B_IGNORE_IP` : The list of IP addresses, CIDR masks or DNS hosts to ignore (default `127.0.0.1/8 ::1`)
* `F2B_BAN_TIME` : The duration for which a host is banned (default `10m`)
* `F2B_FIND_TIME` : The time window in which to seek anomalies in the logs (default `10m`)
* `F2B_MAX_RETRY` : The number of failures before a host gets banned (default `5`)
* `F2B_DEST_EMAIL` : The destination email address used only for interpolations in config files (default `root@localhost`)
* `F2B_SENDER` : The sender email address used only for certain actions (default `root@$(hostname -f)`)
* `F2B_ACTION` : The default action to take upon ban (default `%(action_)s`)
* `F2B_IPTABLES_CHAIN` : Specifies the iptables chain where Fail2Ban rules will be added (default `INPUT`)
* `SSMTP_HOST` : SMTP server host
* `SSMTP_PORT` : SMTP server port (default `25`)
* `SSMTP_HOSTNAME` : Full hostname (default `$(hostname -f)`)
* `SSMTP_USER` : SMTP username
* `SSMTP_PASSWORD` : SMTP password
* `SSMTP_TLS` : SSL/TLS (default `NO`)

> :warning: If you wish to send an email after a ban, you must configure the SSMTP environment variables and set `F2B_ACTION` to `%(action_mw)s` or `%(action_mwl)s`.

### Volumes

* config : Contains custom jails, actions, and filters
* data : Contains Fail2ban's persistent database

## Using this Image

### Command Line

You can use the following minimal command:

```bash
docker run -d --name fail2ban --restart always \
  --network host \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  -v config:/etc/fail2ban \
  -v data:/var/lib/fail2ban \
  -v /var/log:/var/log:ro \
  maltyxx/fail2ban:latest
```

### Command Line (With IPv6 Enabled)

Loaded from a kernel module:

```bash
docker run -d --name fail2ban --restart always \
  --network host \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  --cap-add SYS_MODULE \
  -v config:/etc/fail2ban \
  -v data:/var/lib/fail2ban \
  -v /lib/modules:/lib/modules:/lib/modules:/lib/modules

:ro \
  -v /var/log:/var/log:ro \
  maltyxx/fail2ban:latest
```

## Notes

### `DOCKER-USER` Chain

In Docker 17.06 and later, via [docker/libnetwork#1675](https://github.com/docker/libnetwork/pull/1675), you can add rules to a new table named `DOCKER-USER`. These rules are loaded prior to any automatically created Docker rules. This is helpful for making `iptables` rules established by Fail2Ban persistent.

For older Docker versions, you can simply change `F2B_IPTABLES_CHAIN` to `FORWARD`. This way, all Fail2Ban rules come before Docker's, but these rules will apply to ALL forwarded traffic.

More info: https://docs.docker.com/network/iptables/

### `DOCKER-USER` and `INPUT` Chains

If your Fail2Ban container is attached to the `DOCKER-USER` chain instead of `INPUT`, the rules will only apply **to containers**. This means packets coming into the `INPUT` chain will bypass these rules which are now in the `FORWARD` chain.

This means that, for instance, the [sshd](https://github.com/fail2ban/fail2ban/blob/0.10/config/jail.conf) jail may not work as intended. In this case, you might need another Fail2Ban container.

### Using fail2ban-client

[Fail2ban commands](http://www.fail2ban.org/wiki/index.php/Commands) can be executed through the container. Here's an example if you want to manually ban an IP:

```bash
docker exec -t <CONTAINER> fail2ban-client set <JAIL> banip <IP>
```

### Custom Actions, Filters, and Jails

Custom actions, filters, and jails can be added in `/etc/fail2ban/action.d`, `/etc/fail2ban/filter.d`, and `/etc/fail2ban/jail.d`.

> :warning: You need to restart the container to apply changes.
