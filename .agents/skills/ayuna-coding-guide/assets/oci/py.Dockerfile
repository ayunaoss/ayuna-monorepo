# Stage 1: Builder
FROM ghcr.io/ayunaoss/ayuna-oci-builder:trixie-slim AS builder

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service
ARG TIMEZONE=UTC

COPY --chown=${AYUNA_UID}:${AYUNA_GID} . ${AYUNA_HOME}/${AYUNA_PROJECT}
WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

RUN  find . -type d -name "__pycache__" -exec rm -rf {} + \
    && rm -rf .venv .git uv.lock \
    && uv --version && uv sync --active --refresh --no-cache --index-strategy unsafe-best-match

RUN python -m compileall -b -q $(ls -d */ | grep -v "^\.") && \
    find . -path ./.venv -prune -o -type f -name "*.py" ! -name "main.py" -exec rm {} +

# Stage 2: Final service image
FROM ghcr.io/ayunaoss/ayuna-oci-py:trixie-slim

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service
ARG TIMEZONE=UTC

RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

ENV PATH="${AYUNA_HOME}/${AYUNA_PROJECT}/.venv/bin:${PATH}"

COPY --chown=${AYUNA_UID}:${AYUNA_GID} --from=builder ${AYUNA_HOME} ${AYUNA_HOME}
WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

CMD ["python3", "-m", "main"]
