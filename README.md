# maltyxx/docker-fail2ban

## Execution

```
docker run -ti --name=fail2ban --privileged --net=host --rm -v /var/lib/fail2ban:/var/lib/fail2ban -v /var/log:/var/log:ro maltyxx/fail2ban:latest
```

## Use fail2ban-client
Fail2ban commands can be used through the container. Here is an example if you want to ban an IP manually :

docker exec -it <CONTAINER> fail2ban-client set <JAIL> banip <IP>
