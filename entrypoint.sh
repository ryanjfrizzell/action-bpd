#!/bin/sh
set -exo
echo $@
docker_registry_url=$1
docker_registry_owner=$2
docker_repository=$3
docker_image=$4
docker_username=$5
docker_password=$6
dockerfile=$7
docker_image_tag=$8

# we attempt to build our registry image name here....we try to support as much as we can

if [[ -z $docker_registry_owner ]]; then
  # this gives us a shortculd if you just want to feed the registry path via docker_registry_url 
  # and set us an image to use
  docker_registry_image="${docker_registry_url}/${docker_image}"
else
  # otherwise we try to assemble your docker image based on gihub's repo standard
  # https://help.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages
  docker_registry_image="${docker_registry_url}/${docker_registry_owner}/${docker_repository}/${docker_image}"
fi
if [[ -z $docker_registry_image ]]; then
    echo 'we failed to assemble a docker registry/image combination'
    exit 3
fi
echo "docker image set to ${docker_registry_image}"
# login to docker
echo $docker_password | docker login ${docker_registry_image} -u ${docker_username} --password-stdin
echo "docker build -t tmpimage -f ${dockerfile} ."
docker build -t tmpimage -f ${dockerfile} .
docker tag tmpimage ${docker_registry_image}:${docker_image_tag}
docker push  ${docker_registry_image}:${docker_image_tag}
image_info=$(docker image ls)
echo ::set-output name=imageinfo::$image_info
