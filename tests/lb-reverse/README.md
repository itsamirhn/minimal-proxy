# Test: Load Balance + Reverse Tunnel

Single bridge that acts as both a load balancer and reverse tunnel endpoint. server1 and server2 each serve as both VLESS proxy servers and reverse tunnel portals.

```
┌─ restricted (internal) ────────────────────────┐
│  httpbin :80  <──  bridge (xbridge)            │
└────────────────────────┼───────────────────────┘
                         │ also on backend
┌─ backend ──────────────┼───────────────────────┐
│                   bridge :443                  │
│  ┌─ LB ──────── (VLESS in + 2x reverse)       │
│  │                  ↑↑ tunnels out to :444     │
│  ├→ server1 :443 (VLESS) + :444/:1080 (portal)│  :1081
│  └→ server2 :443 (VLESS) + :444/:1080 (portal)│  :1082
│        ↑                                       │
│     client :1080                               │
└────────────────────────────────────────────────┘
```

**Normal path (LB):** client :1080 -> bridge -> round-robin -> server1/server2 :443 -> internet

**Reverse path:** server1 :1081 or server2 :1082 SOCKS5 -> portal -> tunnel -> bridge -> httpbin (restricted)

## Run

```bash
docker compose up -d
```

## Verify

1. Normal LB — traffic reaches internet through load-balanced servers:

```bash
for i in 1 2 3 4; do curl -s --socks5-hostname 127.0.0.1:1080 http://httpbin.org/ip; echo; done
docker compose logs bridge | grep "tunneling request.*httpbin.org"
# Should show alternating server1:443 / server2:443
```

2. Reverse via server1 — reaches httpbin on restricted network:

```bash
curl --socks5-hostname 127.0.0.1:1081 http://httpbin/ip
```

3. Reverse via server2 — same target, different portal:

```bash
curl --socks5-hostname 127.0.0.1:1082 http://httpbin/ip
```

4. Negative test — servers cannot reach httpbin directly:

```bash
docker compose exec server1 wget -qO- --timeout=3 http://httpbin/ip
docker compose exec server2 wget -qO- --timeout=3 http://httpbin/ip
# Both should fail (no route)
```

## Cleanup

```bash
docker compose down
```
