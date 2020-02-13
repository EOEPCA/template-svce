#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail

docker run -d --rm -p 8080:7000 --name template-svc $DOCKER_USERNAME/template-service:travis_${TRAVIS_BRANCH}_$TRAVIS_BUILD_NUMBER
sleep 15  # wait for startup
curl -s http://localhost:8080/search  # trivial smoke test
