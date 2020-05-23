FROM concourse/concourse:6.1-ubuntu

RUN mkdir -p /ci/web && \
    /usr/local/concourse/bin/concourse generate-key -t rsa -f /ci/web/session_signing_key && \
    /usr/local/concourse/bin/concourse generate-key -t ssh -f /ci/web/tsa_host_key

RUN mkdir -p /ci/worker_a && \
    /usr/local/concourse/bin/concourse generate-key -t ssh -f /ci/worker_a/worker_key && \
    cp /ci/web/tsa_host_key.pub /ci/worker_a/tsa_host_key.pub

RUN mkdir -p /ci/worker_b && \
    /usr/local/concourse/bin/concourse generate-key -t ssh -f /ci/worker_b/worker_key && \
    cp /ci/web/tsa_host_key.pub /ci/worker_b/tsa_host_key.pub

RUN touch /ci/web/authorized_worker_keys && \
    cat /ci/worker_a/worker_key.pub | tee -a /ci/web/authorized_worker_keys && \
    cat /ci/worker_b/worker_key.pub | tee -a /ci/web/authorized_worker_keys

ADD tls /ci/ca
