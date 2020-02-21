#!/bin/sh
set -exo
echo $1
echo $@
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
