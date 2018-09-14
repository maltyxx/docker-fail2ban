# maltyxx/docker-fail2ban

## Execution

```
docker run -ti --name=fail2ban --privileged --net=host --rm -v /var/lib/fail2ban:/var/lib/fail2ban -v /var/log:/var/log:ro maltyxx/fail2ban:latest
```
