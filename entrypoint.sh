#!/bin/sh
set -exo
docker_registry_url = $1
docker_registry_repo = $2
docker_image = $3
docker_username = $4
docker_password = $5
dockerfile = $6

if [[ $# -ne 6 ]]; then
    echo "missing one or more arguments"
fi
if [[ -e docker_registry_repo ]]; then
  docker_registry="${docker_registry_url}/${docker_registry_repo}"
else
  docker_registry="${docker_registry_url}"
fi
docker_image="${docker_registry}/${docker_image}"
echo "docker image set to ${docker_image}"
#docker login ${docker_registry_url} -u ${docker_username} -p ${docker_password}
echo "docker build -t tmpimage -f ${dockerfile} ."
docker build -t tmpimage -f ${dockerfile} .
docker tag tmpimage ${docker_image}:latest
docker push  ${docker_image}:latest
docker image ls tmpimage -q
