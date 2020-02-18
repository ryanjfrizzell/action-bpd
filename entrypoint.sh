#!/bin/sh
set -eo
ls -al
env
docker login -u ${docker_username} -p ${docker_password}
docker build -t tmpimage -f ${dockerfile} .
docker tag tmpimage ${docker_registry}
docker push  ${docker_registry}
docker image ls tmpimage -q
