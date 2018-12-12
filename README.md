# maltyxx/docker-fail2ban

## About

🐳 [Fail2ban](https://www.fail2ban.org) Docker image based on Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/maltyxx/) my other 🐳 Docker images!

## Docker

### Environment variables

* `TZ` : The timezone assigned to the container (default `UTC`)
* `F2B_LOG_LEVEL` : Log level output (default `INFO`)
* `F2B_DB_PURGE_AGE` : Age at which bans should be purged from the database (default `1d`)
* `F2B_MAX_RETRY` : Number of failures before a host get banned (default `5`)
* `F2B_DEST_EMAIL` : Destination email address used solely for the interpolations in configuration files (default `root@localhost`)
* `F2B_SENDER` : Sender email address used solely for some actions (default `root@$(hostname -f)`)
* `F2B_ACTION` : Default action on ban (default `%(action_)s`)
* `F2B_IPTABLES_CHAIN` : Specifies the iptables chain to which the Fail2Ban rules should be added (default `INPUT`)
* `SSMTP_HOST` : SMTP server host
* `SSMTP_PORT` : SMTP server port (default `25`)
* `SSMTP_HOSTNAME` : Full hostname (default `$(hostname -f)`)
* `SSMTP_USER` : SMTP username
* `SSMTP_PASSWORD` : SMTP password
* `SSMTP_TLS` : SSL/TLS (default `NO`)

> :warning: If you want email to be sent after a ban, you have to configure SSMTP env vars and set F2B_ACTION to `%(action_mw)s` or `%(action_mwl)s`

### Volumes

* config : Contains customs jails, actions and filters
* data : Contains Fail2ban persistent database

## Use this image

### Command line

You can also use the following minimal command :

```bash
docker run -d --name fail2ban --restart always \
  --network host \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  -v config:/etc/fail2ban \
  -v data:/var/lib/fail2ban \
  -v /lib/modules:/lib/modules:/lib/modules:/lib/modules:ro \
  -v /var/log:/var/log:ro \
  maltyxx/fail2ban:latest
```

## Notes

### `DOCKER-USER` chain

In Docker 17.06 and higher through [docker/libnetwork#1675](https://github.com/docker/libnetwork/pull/1675), you can add rules to a new table called `DOCKER-USER`, and these rules will be loaded before any rules Docker creates automatically. This is useful to make `iptables` rules created by Fail2Ban persistent.

If you have an older version of Docker, you may just change `F2B_IPTABLES_CHAIN` to `FORWARD`. This way, all Fail2Ban rules come before any Docker rules but these rules will now apply to ALL forwarded traffic.

More info : https://docs.docker.com/network/iptables/

### `DOCKER-USER` and `INPUT` chains

If your Fail2Ban container is attached to `DOCKER-USER` chain instead of `INPUT`, the rules will be applied **only to containers**. This means that any packets coming into the `INPUT` chain will bypass these rules that now reside under the `FORWARD` chain.

This implies that [sshd](https://github.com/fail2ban/fail2ban/blob/0.10/config/jail.conf) jail for example will not work as intended. You can create another Fail2Ban container.

### Use fail2ban-client

[Fail2ban commands](http://www.fail2ban.org/wiki/index.php/Commands) can be used through the container. Here is an example if you want to ban an IP manually :

```bash
docker exec -t <CONTAINER> fail2ban-client set <JAIL> banip <IP>
```

### Custom actions, filters and jails

Custom actions, filters and jails can be added in `/etc/fail2ban/action.d`, `/etc/fail2ban/filter.d` and `/etc/fail2ban/jail.d`.

> :warning: Container has to be restarted to propagate changes
