# Test: Bridge (client -> bridge -> server)

Client connects through a TCP bridge relay to the VLESS server.

```
User :1080 -> client (SOCKS5) -> bridge (tproxy TCP relay) -> server (VLESS) -> internet
```

## Run

```bash
docker compose up -d
```

## Verify

```bash
curl --socks5-hostname 127.0.0.1:1080 http://httpbin.org/ip
```

Should return a JSON response with an IP address. Check bridge logs to confirm traffic flowed through it:

```bash
docker compose logs bridge
```

You should see accepted/connected lines from tproxy.

## Cleanup

```bash
docker compose down
```
