#!/bin/bash

curl -sL https://github.com/docker/app/releases/download/v0.9.0-zeta1/docker-app-linux.tar.gz | tar -xvz
mv docker-app-plugin-linux ~/.docker/cli-plugins/docker-app