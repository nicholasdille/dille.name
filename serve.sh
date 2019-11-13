#!/bin/bash

docker run -it --network host --mount type=bind,source=$PWD/.bundle,target=/bundle --env BUNDLE_PATH=/bundle --mount type=bind,source=$PWD,target=/src --workdir /src jekyll/jekyll:stable bundle exec jekyll serve 
