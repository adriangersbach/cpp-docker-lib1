#!/bin/bash

IMAGE_NAME="age/alpine-cpp-lib1"

docker rmi ${IMAGE_NAME}
docker build -t ${IMAGE_NAME} .
