# Stage 1: Builder
FROM ghcr.io/ayunaoss/ayuna-oci-builder:trixie-slim AS builder

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service

COPY --chown=${AYUNA_UID}:${AYUNA_GID} . ${AYUNA_HOME}/${AYUNA_PROJECT}
WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

RUN go mod tidy && go build -o ${AYUNA_HOME}/${AYUNA_PROJECT}/bin/${AYUNA_PROJECT} . && \
    chmod +x ${AYUNA_HOME}/${AYUNA_PROJECT}/bin/${AYUNA_PROJECT}

# Stage 2: Runner
FROM ghcr.io/ayunaoss/ayuna-oci-base:trixie-slim AS runner

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service

# The OpenDAL Go binding (github.com/apache/opendal/bindings/go) loads libffi at
# run time through purego, so the runner needs libffi8. Harmless for other apps.
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends libffi8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

COPY --from=builder --chown=${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}/bin/${AYUNA_PROJECT} ./bin/${AYUNA_PROJECT}

ENTRYPOINT ["./bin/${AYUNA_PROJECT}"]
