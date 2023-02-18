FROM docker:23.0-rc@sha256:e549f37f4cbcc307574ac7e83269a13cc076672954fd6218b99ee4316f0db76a

WORKDIR /root/.docker/cli-plugins
COPY docker-distribution docker-distribution
RUN apk add --update-cache --no-cache bash curl jq \
 && chmod +x *