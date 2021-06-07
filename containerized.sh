#!/bin/bash
set -eo pipefail
BUILD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUN_COMMAND=${@}

if [[ -n $RUN_COMMAND ]]; then
    docker-compose run client ${RUN_COMMAND}
else
    docker-compose build client
fi