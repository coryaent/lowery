ARG CADDY_VERSION=2.7.6
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/gamalan/caddy-tlsredis \
    --with github.com/caddy-dns/gandi \
    --with github.com/caddyserver/cache-handler

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]

CMD ["docker-proxy"]
