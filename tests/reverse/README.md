# Test: Reverse Tunnel (portal + bridge)

Bridge (restricted network) connects out to portal (public). Users connect to portal's SOCKS5 to reach services on the restricted network.

```
┌─ restricted_network ──────────────────┐
│  httpbin :80  <--  bridge (xray)  ----┼--┐
└───────────────────────────────────────┘  │ tunnel
┌─ public_network ──────────────────────┐  │
│  portal (xray) SOCKS5 :1080  <--------┼--┘
└───────────────────────────────────────┘
```

httpbin is only on `restricted_network`. Portal cannot reach it directly — only through the bridge tunnel.

## Run

```bash
docker compose up -d
```

## Verify

1. Confirm httpbin is NOT directly reachable:

```bash
docker compose exec portal wget -qO- --timeout=3 http://httpbin/ip
# Should fail (no route)
```

2. Confirm reverse tunnel works:

```bash
curl --socks5-hostname 127.0.0.1:1080 http://httpbin/ip
# Should return {"origin": "172.x.x.x"}
```

The origin IP is the bridge's address on the restricted network, proving traffic went through the tunnel.

## Cleanup

```bash
docker compose down
```
