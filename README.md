### Dockerized Pocketbase

Unoffical Pocketbase Docker Container

Support the original project: https://github.com/pocketbase/pocketbase


This Repo sets up the Github Actions to build and deploy to Dockerhub the `azatecas/pocketbase` multiarch image.
It does not build pocketbase from scratch, but rather pull the official release from the original Pocketbase Repo and containarize it.

Current pocketbase architecture supported by this repo:
- amd64
- arm64
- armv7

This image is being used in production, so we will do our best to build after each new Pocketbase release, although it may take a few days.

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

`ENCRYPTION` - OPTIONAL is used to encrypt settings in the current pocketbase instance.
`COMMON_PATH` - refers to the root of the project. 

for more read the offical Pocketbase documentation: https://pocketbase.io/docs