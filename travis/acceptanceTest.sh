#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail

# Check presence of environment variables
TRAVIS_BRANCH="${TRAVIS_BRANCH:-develop}"
TRAVIS_BUILD_NUMBER="${TRAVIS_BUILD_NUMBER:-0}"

docker run -d --rm -p 8080:7000 --name template-svc ${DOCKER_USERNAME}/template-service:travis_${TRAVIS_BRANCH}_${TRAVIS_BUILD_NUMBER}

until [ "`docker inspect -f {{.State.Running}} template-svc`"=="true" ]; do
  sleep 0.1;
done;

curl -s http://localhost:8080/search # trivial smoke test
