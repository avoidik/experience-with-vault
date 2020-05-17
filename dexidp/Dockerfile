FROM quay.io/dexidp/dex:v2.24.0

ADD tls /etc/dex/tls
COPY config.yaml /etc/dex/cfg/config.yaml

ENTRYPOINT ["/usr/local/bin/dex"]
CMD ["serve", "/etc/dex/cfg/config.yaml"]
