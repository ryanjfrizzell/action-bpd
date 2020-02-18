#!/bin/sh
set -eo
docker login -u ${docker_username} -p ${docker_password}
docker build -t tmpimage -f ${dockerfile} .
docker tag tmpimage ${docker_registry}:latest
docker push  ${docker_registry}:latest
docker image ls tmpimage -q
