# Test: Load Balance (client -> xbridge -> 2 servers)

Client connects through xbridge which round-robin load balances between two VLESS servers.

```
                        ┌-> server1 (VLESS) -> internet
User :1080 -> client -> xbridge (round-robin)
                        └-> server2 (VLESS) -> internet
```

## Run

```bash
docker compose up -d
```

## Verify

```bash
curl --socks5-hostname 127.0.0.1:1080 http://httpbin.org/ip
```

Should return a JSON response. Run multiple requests and check xbridge logs to confirm traffic is distributed across both servers:

```bash
for i in 1 2 3 4; do curl -s --socks5-hostname 127.0.0.1:1080 http://httpbin.org/ip; done
docker compose logs xbridge | grep "tunneling request"
```

You should see requests going to both `server1:443` and `server2:443`.

## Cleanup

```bash
docker compose down
```
