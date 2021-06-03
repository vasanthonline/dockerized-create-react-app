#!/bin/bash
set -eo pipefail
BUILD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOCKER_REPO="${DOCKER_REPO:-dockerized-cra}"
BRANCH="${BRANCH:-local}"
RUN_COMMAND=""

case "$1" in
    --no-build)
        echo "Skip building a docker image. Using existing $DOCKER_REPO:$BRANCH image."
        RUN_COMMAND=${@:2}
        ;;
    *)
        echo "Building docker image $DOCKER_REPO:$BRANCH..."
        docker build -t $DOCKER_REPO:$BRANCH --build-arg UID=$UID ${BUILD_ROOT}
        RUN_COMMAND=${@}
        ;;
esac

DOCKER_ARGS="--rm --user ${UID} -p 3000:3000 --workdir=/opt/dockerized-cra/app"

if [ -t 1 ]; then
  DOCKER_ARGS="${DOCKER_ARGS} -it"
fi

# Bind host directory to docker container, so that changes made are visible on both sides.
DOCKER_ARGS="${DOCKER_ARGS} -v ${BUILD_ROOT}:/opt/dockerized-cra/app"

# This empty bind-mount blocks the host node_modules from being visible inside the container
DOCKER_ARGS="${DOCKER_ARGS} -v /opt/dockerized-cra/node_modules"

if [[ -n $RUN_COMMAND ]]; then
    docker run $DOCKER_ARGS \
    $DOCKER_REPO:$BRANCH \
    ${RUN_COMMAND}
fi
