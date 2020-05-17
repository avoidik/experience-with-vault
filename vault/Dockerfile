FROM consul:1.7.3 AS consul

FROM vault:1.4.1

# prepare consul client

RUN addgroup -g 5000 -S consul && \
    adduser -S -G consul consul

RUN mkdir -p /consul/data && \
    mkdir -p /consul/config && \
    chown -R consul:consul /consul

RUN mkdir /consul/sock && \
    chmod -R 777 /consul/sock && \
    chown -R consul:consul /consul/sock

COPY --from=consul /etc/nsswitch.conf /etc/nsswitch.conf
COPY --from=consul /bin/consul /bin/consul
COPY --from=consul /usr/local/bin/docker-entrypoint.sh /usr/local/bin/consul-entrypoint.sh

ADD tls-consul /consul/ca
COPY consul-client.json /consul/config/consul-client.json

# prepare vault

RUN addgroup vault consul

ADD tls-vault /vault/ca
COPY vault.json /vault/config/vault.json

RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/vault-entrypoint.sh

# custom entry-point

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
