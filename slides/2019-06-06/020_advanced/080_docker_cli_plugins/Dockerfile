FROM docker:22.06-rc@sha256:23c65a406b81d4394730b9bb61f84b7938d820a3c52800d979655e74a3a2c48b

WORKDIR /root/.docker/cli-plugins
COPY docker-distribution docker-distribution
RUN apk add --update-cache --no-cache bash curl jq \
 && chmod +x *