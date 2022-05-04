FROM docker:20.10-rc@sha256:e52651216e0b5ac26e6af91dbf569f071278cead01facbe40f96a2c3f3d4c53a

WORKDIR /root/.docker/cli-plugins
COPY docker-distribution docker-distribution
RUN apk add --update-cache --no-cache bash curl jq \
 && chmod +x *