#!/bin/sh

read -p "What kind of package build? [alpine/ubuntu]: " choice
case "$choice" in
  alpine ) echo "Let's start assembling...";;
  ubuntu ) echo "Let's start assembling...";;
  * ) echo "Required [alpine/ubuntu]"; exit;;
esac

export DOCKER_DEFAULT_PLATFORM=linux/amd64

IMAGE_RAW="flutter-aurora-raw-$choice"
IMAGE_RUN="flutter-aurora-run-$choice"
IMAGE_DONE="flutter-aurora-$choice"

# Docker base build
docker build $(sed 's/^/--build-arg /' .env | xargs) --no-cache --progress plain --tag $IMAGE_RAW -f ./Dockerfile-$choice .

# Run container with privileged
docker run --rm --name $IMAGE_RUN -itd --privileged $IMAGE_RAW

# Install PSDK.
# For install need privileged mode.
docker exec -it $IMAGE_RUN /bin/bash -c "aurora-cli api --route='/psdk/install?version=$(sed 's/PSDK=//' .env | grep '=' -v)'"
docker exec -it $IMAGE_RUN /bin/bash -c "sudo rm -rf ~/Downloads/*"

echo 'Save state container...'
docker commit $IMAGE_RUN $IMAGE_DONE

echo 'Stop container...'
docker container stop $IMAGE_RUN

echo 'Remove raw image...'
docker rmi -f $IMAGE_RAW
