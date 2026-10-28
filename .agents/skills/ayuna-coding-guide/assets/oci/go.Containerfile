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

WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

COPY --from=builder --chown=${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}/bin/${AYUNA_PROJECT} ./bin/${AYUNA_PROJECT}

ENTRYPOINT ["./bin/${AYUNA_PROJECT}"]
