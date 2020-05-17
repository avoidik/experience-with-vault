FROM consul:1.7.3

ADD tls /consul/ca
COPY consul.json /consul/config/consul.json

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["agent", "-server"]
