# Test: Basic (client -> server)

Direct VLESS connection from client to server.

```
User :1080 -> client (SOCKS5) -> server (VLESS) -> internet
```

## Run

```bash
docker compose up -d
```

## Verify

```bash
curl --socks5-hostname 127.0.0.1:1080 http://httpbin.org/ip
```

Should return a JSON response with an IP address.

## Cleanup

```bash
docker compose down
```
