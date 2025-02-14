ARG CADDY_VERSION=2.8.4
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/gamalan/caddy-tlsredis \
    --with github.com/caddy-dns/gandi \
    --with github.com/caddy-dns/directadmin \
    --with github.com/caddy-dns/desec \
    --with github.com/caddyserver/cache-handler \
    --with github.com/greenpau/go-authcrunch \
    --with github.com/root-sector/caddy-storage-mongodb

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]

CMD ["docker-proxy"]
