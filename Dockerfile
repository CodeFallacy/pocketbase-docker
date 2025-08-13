FROM alpine:latest

ARG PB_VERSION=0.29.2

ARG TARGETARCH

# Set ARCH from TARGETARCH (default to amd64)
# Pocketbase uses "amd64" or "arm64" in their asset names
ARG ARCH
RUN if [ -z "$ARCH" ]; then \
      case "$TARGETARCH" in \
        amd64) export ARCH=amd64 ;; \
        arm64) export ARCH=arm64 ;; \
        arm) export ARCH=armv7 ;; \
        *) echo "Unsupported arch: $TARGETARCH" && exit 1 ;; \
      esac && \
      echo "Detected ARCH=$ARCH"; \
    fi

RUN apk add --no-cache \
    unzip \
    ca-certificates

# download and unzip PocketBase x86 64-bit
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${ARCH}.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# uncomment to copy the local pb_migrations dir into the image
# COPY ./pb_migrations /pb/pb_migrations

# uncomment to copy the local pb_hooks dir into the image
# COPY ./pb_hooks /pb/pb_hooks

EXPOSE 8080

# start PocketBase
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
