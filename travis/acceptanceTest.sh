#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail
# Not supported in travis (xenial)
# shopt -s inherit_errexit

docker run -d --rm -p 8080:7000 --name cat-svc $DOCKER_USERNAME/catalogue-service:travis_${TRAVIS_BRANCH}_$TRAVIS_BUILD_NUMBER
sleep 15  # wait for startup
# docker ps -a
curl -s http://localhost:8080/search | jq '.'  # trivial smoke test
# docker logs cat-svc
