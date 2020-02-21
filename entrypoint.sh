#!/bin/sh
set -exo
echo $@
docker_registry_url=$1
docker_registry_repo=$2
docker_image=$3
docker_username=$4
docker_password=$5
dockerfile=$6

if [[ $# -ne 6 ]]; then
    echo "missing one or more arguments"
    exit 3
fi

docker_registry_image="${docker_registry_url}/${docker_registry_repo}/${docker_image}"

echo "docker image set to ${docker_registry_image}"
docker login ${docker_registry_url} -u ${docker_username} -p ${docker_password}
echo "docker build -t tmpimage -f ${dockerfile} ."
docker build -t tmpimage -f ${dockerfile} .
docker tag tmpimage ${docker_registry_image}:latest
docker push  ${docker_registry_image}:latest
docker image ls tmpimage -q
