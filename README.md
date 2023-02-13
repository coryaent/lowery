# Lowery
![Francis_Ouimet_carried_and_Eddie_Lowery_1913_1](https://user-images.githubusercontent.com/20460411/121463582-5260bb00-c980-11eb-8413-a4e84376a251.jpg)

## Overview
[Lowery](https://caddiehalloffame.org/all-hall-of-fame-inductees/175-eddie-lowery) is [Caddy](https://caddyserver.com) compiled with plugins for [Docker](https://www.docker.com) and [Redis](https://redis.io).

## Usage
Note that the below example should not be considered secure under any circumstances and is not intended to be used in any way; it is included here for documentary purposes only.
```yamlversion: '3.7'
x-common-env: &common-env
  CADDY_CONTROLLER_NETWORK: 10.200.200.0/24
  CADDY_INGRESS_NETWORKS: www

services:
  socket:
    image: alpine/socat
    command: "-dd TCP-L:2375,fork UNIX:/var/run/docker.sock"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - internal
    deploy:
      mode: global
      placement:
        constraints:
          - "node.role==manager"

  keyj:
    image: stevecorya/keyj
    environment:
      - SERVICE_NAME={{.Service.Name}}
    networks:
      - internal
    volumes:
      - data:/data
    deploy:
      mode: global
      placement:
        constraints:
          - "node.labels.enterprises.corya.ingress==true"

  server:
    image: stevecorya/lowery
    ports:
      - target: 443
        published: 443
        mode: host
    networks:
      - www
      - control
      - internal
    environment:
      <<: *common-env
      CADDY_DOCKER_MODE: server
    deploy:
      mode: global
      placement:
        constraints:
          - "node.labels.enterprises.corya.ingress==true"
      labels:
        caddy_controlled_server:

  controller:
    image: stevecorya/lowery
    networks:
      - www
      - control
      - internal
    environment:
      <<: *common-env
      CADDY_DOCKER_MODE: controller
      DOCKER_HOST: http://socket:2375
    deploy:
      labels:
        caddy.email: steve@corya.net
        caddy.storage: redis
        caddy.storage.redis.host: keyj
        caddy.storage.redis.port: 6379
  whoami2:
    image: containous/whoami
    networks:
      - www
    labels:
      caddy: whoami2.corya.co
      caddy.reverse_proxy: "{{upstreams 80}}"

networks:
  www:
    external: true
  control:
    driver: overlay
    driver_opts:
      encrypted: "true"
    ipam:
      driver: default
      config:
        - subnet: "10.200.200.0/24"
  internal:
    driver: overlay
    driver_opts:
      encrypted: "true"

volumes:
  data:

```

## Recognizing
- [Gamalan](https://github.com/gamalan) for [Caddy Cluster / Certmagic TLS cluster support for Redis](https://github.com/gamalan/caddy-tlsredis)
- [Lucas Loretz](https://github.com/lucaslorentz) for [Caddy-Docker-Proxy](https://github.com/lucaslorentz/caddy-docker-proxy)
