#!/bin/sh
set -xeo
env
echo $@
docker_registry_url=$1
docker_registry_owner=$2
docker_repository=$3
docker_image=$4
docker_username=$5
docker_password=$6
dockerfile=$7
docker_image_tag=$8
docker_registry=$9


# otherwise we try to assemble your docker image based on gihub's repo standard
# https://help.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages
if [[ -z $docker_registry ]]; then
    docker_registry_image="${docker_registry_url}/${docker_registry_owner}/${docker_repository}/${docker_image}"
else
    docker_registry_image="${docker_registry}"
fi
tagged_image="${docker_registry_image}:${docker_image_tag}"
echo "docker image set to ${docker_registry_image}"
echo "using tagged image of ${tagged_image}"

if [[ -z $docker_registry_image ]]; then
    echo 'we failed to assemble a docker registry/image combination'
    exit 3
fi
# go with the do
echo $docker_password | docker login ${docker_registry_image} -u ${docker_username} --password-stdin
echo "docker build -t ${tagged_image}  -f ${dockerfile} ."
docker build -t ${tagged_image} -f ${dockerfile} .
docker push  ${tagged_image}
image_info=$(docker image ls | grep ${docker_registry_image})
echo ::set-output name=imageinfo::$image_info
