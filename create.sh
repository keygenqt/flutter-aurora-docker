#!/bin/sh

export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Load .env
USER=$(sed 's/USER=//' .env | grep '=' -v)
CLI=$(sed 's/CLI=//' .env | grep '=' -v)
PSDK=$(sed 's/PSDK=//' .env | grep '=' -v)
FLUTTER=$(sed 's/FLUTTER=//' .env | grep '=' -v)

IMAGE_RAW='flutter-aurora-raw'
IMAGE_RUN='flutter-aurora-run'
IMAGE_DONE='flutter-aurora'

# Docker base build
docker build $(sed 's/^/--build-arg /' .env | xargs) --no-cache --progress plain --tag $IMAGE_RAW .

# Run container with privileged
docker run --rm --name $IMAGE_RUN -itd --privileged $IMAGE_RAW

# Function for exec in container
containerExec() {
    docker exec -it $IMAGE_RUN /bin/bash -c "$1"
}

# Install PSDK.
# For install need privileged mode.
containerExec "python3 aurora-cli-$CLI.pyz api --route='/psdk/install?version=$PSDK'"
containerExec "sudo rm -rf ~/Downloads/*"

# Configure Flutter after install PSDK.
containerExec "flutter config --enable-aurora-devices"
containerExec "flutter config --aurora-psdk-dir=/home/${USER}/AuroraPlatformSDK-${PSDK}/sdks/aurora_psdk"

# Save container
echo
echo 'Save state container...'
docker commit $IMAGE_RUN $IMAGE_DONE

# Stop with auto remove container
echo
echo 'Stop container...'
docker container stop $IMAGE_RUN

# Remove raw image, it is no longer needed
echo
echo 'Remove raw image...'
docker rmi -f $IMAGE_RAW
