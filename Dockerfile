# Caddy
FROM golang:buster AS caddy-compiler

WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl && \
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg && \
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-xcaddy.list && \
	apt-get update && \
	apt-get install -y xcaddy && \
	xcaddy build \
		--output /usr/local/bin/caddy \
		--with github.com/shcorya/caddy-docker-proxy \
	    --with github.com/gamalan/caddy-tlsredis \
        --with github.com/yroc92/postgres-storage
		
# Default Certificates 
FROM alpine:3.14 AS alpine
RUN apk add -U --no-cache ca-certificates

#####################
# primary container #
#####################
FROM debian:buster-slim

EXPOSE 80
EXPOSE 443
EXPOSE 2019

WORKDIR /usr/local/src

COPY --from=caddy-compiler /usr/local/bin/caddy /usr/local/bin/caddy
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY ./Caddyfile ./Caddyfile

ENTRYPOINT ["/usr/local/bin/caddy"]

CMD ["docker-proxy"]
