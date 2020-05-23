FROM quay.io/dexidp/dex:v2.24.0

ADD tls /etc/dex/tls
COPY config.yaml.tpl /etc/dex/cfg/config.yaml.tpl

USER root
ARG ISSUER_URL
ARG MACHINE_IP
RUN sed \
    -e "s#___ISSUER_URL___#${ISSUER_URL}#g" \
    -e "s#___MACHINE_IP___#${MACHINE_IP}#g" \
    /etc/dex/cfg/config.yaml.tpl > /etc/dex/cfg/config.yaml && \
    rm -f /etc/dex/cfg/config.yaml.tpl
USER 1001:1001

ENTRYPOINT ["/usr/local/bin/dex"]
CMD ["serve", "/etc/dex/cfg/config.yaml"]
