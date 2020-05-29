#!/bin/bash
set -o errexit

docker build --tag nicholasdille/jekyll --file Dockerfile.jekyll .
docker run -d --name blog --publish 8081:4000 nicholasdille/jekyll jekyll serve
