FROM docker:22.06-rc@sha256:20e5959ca688ece9233febdd66186d743183aebab8f0b2c4ab50540b8bd6013a

WORKDIR /root/.docker/cli-plugins
COPY docker-distribution docker-distribution
RUN apk add --update-cache --no-cache bash curl jq \
 && chmod +x *