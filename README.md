# minimal-proxy

Dockerized xray-core VLESS proxy setup with server, client, bridge, and xbridge containers.

## Images

| Image | Description |
|-------|-------------|
| `itsamirhn/minimal-proxy-server` | VLESS server (freedom outbound) |
| `itsamirhn/minimal-proxy-client` | SOCKS5 client connecting to a VLESS upstream |
| `itsamirhn/minimal-proxy-bridge` | TCP relay using [tproxy](https://github.com/kevwan/tproxy) |
| `itsamirhn/minimal-proxy-xbridge` | Xray bridge with full config via env |

All images are available on both Docker Hub and GHCR (`ghcr.io/itsamirhn/minimal-proxy/<name>`), for `linux/amd64` and `linux/arm64`.

## Environment Variables

### server

| Env | Description | Required |
|-----|-------------|----------|
| `VLESS_UUID` | VLESS client UUID | Yes |

### client

| Env | Description | Default |
|-----|-------------|---------|
| `VLESS_UUID` | VLESS UUID to authenticate with | Required |
| `VLESS_ADDRESS` | Upstream VLESS server hostname | `xbridge` |
| `VLESS_PORT` | Upstream VLESS server port | `443` |

### bridge

| Env | Description | Default |
|-----|-------------|---------|
| `UPSTREAM_HOST` | Upstream host to forward TCP to | `server` |
| `UPSTREAM_PORT` | Upstream port | `443` |
| `LISTEN_PORT` | Port to listen on | `443` |

### xbridge

| Env | Description | Required |
|-----|-------------|----------|
| `XRAY_CONFIG` | Full xray JSON config | Yes |

## Usage

### Basic: client -> server

```yaml
services:
  server:
    image: itsamirhn/minimal-proxy-server
    environment:
      - VLESS_UUID=<your-uuid>

  client:
    image: itsamirhn/minimal-proxy-client
    environment:
      - VLESS_UUID=<your-uuid>
      - VLESS_ADDRESS=server
    ports:
      - "1080:1080"
```

```bash
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip
```

### With bridge: client -> bridge -> server

```yaml
services:
  server:
    image: itsamirhn/minimal-proxy-server
    environment:
      - VLESS_UUID=<your-uuid>

  bridge:
    image: itsamirhn/minimal-proxy-bridge
    environment:
      - UPSTREAM_HOST=server
      - UPSTREAM_PORT=443

  client:
    image: itsamirhn/minimal-proxy-client
    environment:
      - VLESS_UUID=<your-uuid>
      - VLESS_ADDRESS=bridge
    ports:
      - "1080:1080"
```

### With xbridge: client -> xbridge -> remote VLESS server

```yaml
services:
  xbridge:
    image: itsamirhn/minimal-proxy-xbridge
    environment:
      - XRAY_CONFIG=<full-xray-json-config>

  client:
    image: itsamirhn/minimal-proxy-client
    environment:
      - VLESS_UUID=<your-uuid>
      - VLESS_ADDRESS=xbridge
    ports:
      - "1080:1080"
```

### xbridge: single outbound config

```
XRAY_CONFIG='{"log":{"loglevel":"debug"},"inbounds":[{"port":443,"listen":"0.0.0.0","protocol":"vless","settings":{"clients":[{"id":"<inbound-uuid>","level":0}],"decryption":"none"},"streamSettings":{"network":"tcp"}}],"outbounds":[{"protocol":"vless","settings":{"vnext":[{"address":"<remote-host>","port":<remote-port>,"users":[{"id":"<outbound-uuid>","encryption":"none"}]}]},"streamSettings":{"network":"tcp","security":"none"}}]}'
```

### xbridge: round-robin load balancing with burst observatory

```
XRAY_CONFIG='{"log":{"loglevel":"debug"},"inbounds":[{"port":443,"listen":"0.0.0.0","protocol":"vless","settings":{"clients":[{"id":"<inbound-uuid>","level":0}],"decryption":"none"},"streamSettings":{"network":"tcp"}}],"outbounds":[{"protocol":"vless","tag":"proxy1","settings":{"vnext":[{"address":"<host-1>","port":<port>,"users":[{"id":"<outbound-uuid>","encryption":"none"}]}]},"streamSettings":{"network":"tcp","security":"none"}},{"protocol":"vless","tag":"proxy2","settings":{"vnext":[{"address":"<host-2>","port":<port>,"users":[{"id":"<outbound-uuid>","encryption":"none"}]}]},"streamSettings":{"network":"tcp","security":"none"}}],"routing":{"rules":[{"type":"field","network":"tcp,udp","balancerTag":"lb"}],"balancers":[{"tag":"lb","selector":["proxy"],"strategy":{"type":"roundRobin"}}]},"burstObservatory":{"subjectSelector":["proxy"],"pingConfig":{"destination":"http://www.google.com/generate_204","interval":"10s","connectivity":"http://www.google.com/generate_204","timeout":"5s","sampling":2}}}'
```
