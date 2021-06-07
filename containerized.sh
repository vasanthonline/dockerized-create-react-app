#!/bin/bash
set -eo pipefail
BUILD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUN_COMMAND=""

case "$1" in
    --no-build)
        echo "Skip building a docker image. Using existing image."
        COMPOSE_ARGS="--no-build"
        RUN_COMMAND=${@:2}
        ;;
    *)
        RUN_COMMAND=${@}
        ;;
esac



if [[ -n $RUN_COMMAND ]]; then
    docker-compose run client ${RUN_COMMAND}
fi
