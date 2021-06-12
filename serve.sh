#!/bin/bash

JEKYLL_VERSION=4.2.0

docker run \
    --interactive --tty \
    --rm \
    --volume="$PWD/.bundle:/usr/local/bundle" \
    --mount "type=bind,source=$PWD,target=/srv/jekyll" \
    --workdir /srv/jekyll \
    --publish 127.0.0.1:4000:4000 \
    "jekyll/jekyll:${JEKYLL_VERSION}" \
    jekyll serve
