FROM teddysun/xray

ENV VLESS_UUID=''
ENV VLESS_ADDRESS='xbridge'
ENV VLESS_PORT='443'

COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1080

ENTRYPOINT ["/entrypoint.sh"]
