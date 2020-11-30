## Commando: Tools on Demand

[Commando](https://github.com/lukaszlach/commando) created by [Docker Captain Łukasz Lach](https://www.docker.com/captains/%C5%82ukasz-lach)

Container images are created on demand:

```plaintext
docker run -it --rm cmd.cat/curl
```

Very powerful when troubleshooting networking:

```plaintext
docker run -d --name nginx nginx
docker run -it --rm \
    --net container:nginx \
    --pid container:nginx \
    cmd.cat/netstat/tcpdump/ip/ifconfig/ping
```
