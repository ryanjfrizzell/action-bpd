#!/bin/sh
set -xeo
env
echo $@
docker_registry_url=$INPUT_DOCKER_REGISTRY_URL
docker_registry_owner=$INPUT_DOCKER_REGISTRY_OWNER
docker_repository=$INPUT_DOCKER_REPOSITORY
docker_image=$INPUT_DOCKER_IMAGE
docker_username=$INPUT_DOCKER_USERNAME
docker_password=$INPUT_DOCKER_PASSWORD
dockerfile=$INPUT_DOCKERFILE
docker_image_tag=$INPUT_DOCKER_IMAGE_TAG
docker_registry=$INPUT_DOCKER_REGISTRY
dockerhub=$INPUT_DOCKERHUB
pushDir=$INPUT_PUSHD


if [[ ! -z $pushDir ]]; then
    echo "dectected pushdir pushing to ${pushDir}"
    pushd $pushDir
fi

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
if [[ $dockerhub != 'true' ]]; then
    echo $docker_password | docker login ${docker_registry_image} -u ${docker_username} --password-stdin
else
    echo $docker_password | docker login ${docker_registry_owner} -u ${docker_username} --password-stdin
fi
echo "docker build -t ${tagged_image}  -f ${dockerfile} ."
docker build -t ${tagged_image} -f ${dockerfile} .
docker push  ${tagged_image}
image_info=$(docker image ls | grep ${docker_registry_image})
echo ::set-output name=imageinfo::$image_info
