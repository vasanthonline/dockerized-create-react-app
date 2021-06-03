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

if [[ -n $RUN_COMMAND ]]; then
    docker run -it --rm \
    --user $UID \
    -v ${BUILD_ROOT}:/opt/dockerized-cra/app \
    -v /opt/dockerized-cra/app/node_modules \
    -p 3000:3000 \
    $DOCKER_REPO:$BRANCH \
    ${RUN_COMMAND}
fi
