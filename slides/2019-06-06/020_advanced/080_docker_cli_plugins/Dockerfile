FROM docker:19.03-rc@sha256:a2fab2fd54fddb10492d7cc949fc92be1ef8514067efc0cfbca73670fc535faf

WORKDIR /root/.docker/cli-plugins
COPY docker-distribution docker-distribution
RUN apk add --update-cache --no-cache bash curl jq \
 && chmod +x *