FROM alpine:latest

ARG PB_VERSION=0.29.2

ARG TARGETARCH

ENV PB_VERSION=${PB_VERSION}

RUN apk add --no-cache \
    curl \
    unzip \
    ca-certificates

# TARGETARCH does not supply the exact values we need to we need to do a conditional in the same run command X(

RUN case "$TARGETARCH" in \
      amd64) ARCH=amd64 ;; \
      arm64) ARCH=arm64 ;; \
      arm) ARCH=armv7 ;; \
      *) echo "Unsupported TARGETARCH: $TARGETARCH" && exit 1 ;; \
    esac && \
    curl -fsSL -o /tmp/pb.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${ARCH}.zip" && \
    unzip /tmp/pb.zip -d /pb/ && \
    rm /tmp/pb.zip

# download and unzip PocketBase x86 64-bit
# ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${TARGETARCH}.zip /tmp/pb.zip
# RUN unzip /tmp/pb.zip -d /pb/

# uncomment to copy the local pb_migrations dir into the image
# COPY ./pb_migrations /pb/pb_migrations

# uncomment to copy the local pb_hooks dir into the image
# COPY ./pb_hooks /pb/pb_hooks

EXPOSE 8080

# start PocketBase
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
