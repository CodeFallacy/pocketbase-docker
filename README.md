### Dockerized Pocketbase

Unoffical Pocketbase Docker Container

This Repo sets up the Github Actions to build and deploy to Dockerhub the `azatecas/pocketbase` image.
I do not build pocketbase from scratch, but rather pull the official release from the original Pocketbase Repo and containarize it.

Suggested `docker-compose.yml` configuration

```yml
services:
  pocketbase:
    container_name: pocketbase
    image: azatecas/pocketbase
    restart: unless-stopped
    environment:
      ENCRYPTION: ${ENCRYPTION} # optional (Ensure this is a 32-character long encryption key https://pocketbase.io/docs/going-to-production/#enable-settings-encryption)
    ports:
      - "127.0.0.1:8080:8080"
    volumes:
      - ${COMMON_PATH}/pb_data:/pb/pb_data
      - ${COMMON_PATH}/pb_public:/pb/pb_public # optional
      - ${COMMON_PATH}/pb_hooks:/pb/pb_hooks # optional
    healthcheck: # optional, recommended since v0.10.0
      test: wget --no-verbose --tries=1 --spider http://localhost:8080/api/health || exit 1
      interval: 60s
      timeout: 5s
      retries: 5
```
