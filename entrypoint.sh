#!/bin/bash
set -eo
ls -al
env
docker login -u ${docker_username} -p ${docker_password}
docker build -f ${dockerfile}
