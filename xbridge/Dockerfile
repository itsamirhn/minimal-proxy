FROM teddysun/xray

ENV XRAY_CONFIG='{}'

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
