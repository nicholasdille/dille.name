FROM docker:22.06-rc@sha256:7c01c6f9601d224cc7ad610f76498802098a04018f5160634810dfb55109c635

WORKDIR /root/.docker/cli-plugins
COPY docker-distribution docker-distribution
RUN apk add --update-cache --no-cache bash curl jq \
 && chmod +x *