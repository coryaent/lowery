# Lowery
![Francis_Ouimet_carried_and_Eddie_Lowery_1913_1](https://user-images.githubusercontent.com/20460411/121463582-5260bb00-c980-11eb-8413-a4e84376a251.jpg)

## Overview
[Lowery](https://caddiehalloffame.org/all-hall-of-fame-inductees/175-eddie-lowery) is [Caddy](https://caddyserver.com) compiled with plugins for [Docker](https://www.docker.com) and [Redis](https://redis.io).

## Usage
Note that the below example should not be considered secure under any circumstances and is not intended to be used in any way; it is included here for documentary purposes only.
```yaml
version: '3.7'

services:

  socket-link:
    image: drakulix/shipwreck
    command: >
      --to="http://0.0.0.0:2375"
    networks:
      - encrypted-overlay
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    deploy:
      mode: global
      placement:
        constraints:
          - "node.role==manager"
    
  reverse-proxy:
    image: lucaslorentz/caddy-docker-proxy
    environment:
      CADDY_INGRESS_NETWORKS: www
      DOCKER_API_VERSION: 1.37
      DOCKER_HOST: http://socket-link:2375
    networks:
      - encrypted-overlay
      - www
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - data:/data
    deploy:
      placement:
        constraints:
          - "node.id==390nbmpc7usaf568ng4zhm1yk"
          
networks:
  encrypted-overlay:
    driver: overlay
    driver_opts:
      encrypted: "true"
  www:
    external: true

volumes:
  data:
```

## Recognizing
- [Gamalan](https://github.com/gamalan) for [Caddy Cluster / Certmagic TLS cluster support for Redis](https://github.com/gamalan/caddy-tlsredis)
- [Lucas Loretz](https://github.com/lucaslorentz) for [Caddy-Docker-Proxy](https://github.com/lucaslorentz/caddy-docker-proxy)
