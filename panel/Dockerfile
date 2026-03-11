FROM ghcr.io/mhsanaei/3x-ui:latest

COPY entrypoint.sh /app/wrapper-entrypoint.sh
COPY backup.sh /app/backup.sh
COPY s3.sh /app/s3.sh
RUN chmod +x /app/wrapper-entrypoint.sh /app/backup.sh /app/s3.sh

ENTRYPOINT ["/app/wrapper-entrypoint.sh"]
