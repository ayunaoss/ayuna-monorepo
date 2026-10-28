# Stage 1: Prepare npm environment
FROM ghcr.io/ayunaoss/ayuna-oci-js:trixie-slim AS base

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service
ARG TIMEZONE=UTC

RUN mkdir ${AYUNA_HOME}/${AYUNA_PROJECT} && \
    chown -R ${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}; \
    npm update -g npm

# Stage 2: Install dependencies
FROM base AS deps

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service

WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

# Install dependencies based on the preferred package manager
COPY --chown=${AYUNA_UID}:${AYUNA_GID} package.json yarn.lock* package-lock.json* pnpm-lock.yaml* .npmrc* ./

RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    elif [ -f pnpm-lock.yaml ]; then pnpm i --frozen-lockfile; \
    else echo "Lockfile not found." && exit 1; \
    fi

# Step 3: Build the application
FROM base AS builder

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service
ARG TIMEZONE=UTC
## Add other ARG entries as needed for the build process

ENV AYUNA_UID=${AYUNA_UID}
ENV AYUNA_GID=${AYUNA_GID}
ENV AYUNA_HOME=${AYUNA_HOME}
ENV AYUNA_PROJECT=${AYUNA_PROJECT}
ENV TIMEZONE=${TIMEZONE}
## Add other ENV entries as needed for the build process

WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

COPY --from=deps --chown=${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}/node_modules ./node_modules
COPY --chown=${AYUNA_UID}:${AYUNA_GID} . .

RUN \
    if [ -f yarn.lock ]; then yarn run build; \
    elif [ -f package-lock.json ]; then npm run build; \
    elif [ -f pnpm-lock.yaml ]; then pnpm run build; \
    else echo "Lockfile not found." && exit 1; \
    fi

# Stage 4: Production image
FROM base AS runner

ARG AYUNA_UID
ARG AYUNA_GID
ARG AYUNA_HOME
ARG AYUNA_PROJECT=my-service
ARG TIMEZONE=UTC

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

WORKDIR ${AYUNA_HOME}/${AYUNA_PROJECT}
USER ayuna

COPY --from=builder --chown=${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}/public ./public
COPY --from=builder --chown=${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}/.next/standalone ./
COPY --from=builder --chown=${AYUNA_UID}:${AYUNA_GID} ${AYUNA_HOME}/${AYUNA_PROJECT}/.next/static ./.next/static

EXPOSE 3000

CMD ["node", "server.js"]
