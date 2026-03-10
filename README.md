# minimal-proxy

Dockerized xray-core VLESS proxy setup.

## Images

| Image | Description |
|-------|-------------|
| `itsamirhn/minimal-proxy-server` | VLESS server |
| `itsamirhn/minimal-proxy-client` | SOCKS5 client |
| `itsamirhn/minimal-proxy-bridge` | TCP relay ([tproxy](https://github.com/kevwan/tproxy)) |
| `itsamirhn/minimal-proxy-xbridge` | Xray with full config via `XRAY_CONFIG` env |

Available on Docker Hub and GHCR (`ghcr.io/itsamirhn/minimal-proxy/*`), for `linux/amd64` and `linux/arm64`.

## Environment Variables

| Image | Env | Default | Required |
|-------|-----|---------|----------|
| server | `VLESS_UUID` | — | Yes |
| client | `VLESS_UUID` | — | Yes |
| client | `VLESS_ADDRESS` | `xbridge` | |
| client | `VLESS_PORT` | `443` | |
| bridge | `UPSTREAM_HOST` | `server` | |
| bridge | `UPSTREAM_PORT` | `443` | |
| bridge | `LISTEN_PORT` | `443` | |
| xbridge | `XRAY_CONFIG` | — | Yes |

## Tests

See [`tests/`](tests/) for working docker-compose examples and configs:

| Test | Scenario |
|------|----------|
| [basic](tests/basic/) | client → server |
| [bridge](tests/bridge/) | client → bridge → server |
| [loadbalance](tests/loadbalance/) | client → xbridge (round-robin) → 2 servers |
| [reverse](tests/reverse/) | portal SOCKS5 → reverse tunnel → bridge → isolated target |
| [lb-reverse](tests/lb-reverse/) | LB + reverse tunnel combined, servers as both VLESS + portal |
