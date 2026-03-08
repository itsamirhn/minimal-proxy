FROM teddysun/xray

ARG VLESS_UUID
RUN test -n "$VLESS_UUID" || { echo "VLESS_UUID build arg is required"; exit 1; }

COPY config.json /etc/xray/config.json
RUN sed -i "s/VLESS_UUID_PLACEHOLDER/$VLESS_UUID/" /etc/xray/config.json

EXPOSE 443
