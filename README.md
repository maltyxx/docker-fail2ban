# maltyxx/docker-fail2ban

## Execution

```
docker run -ti --name=fail2ban --privileged --net=host --rm -v fail2ban_data:/var/lib/fail2ban maltyxx/fail2ban:latest
```
