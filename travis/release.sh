#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail
# Not supported in travis (xenial)
# shopt -s inherit_errexit

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker pull $DOCKER_USERNAME/catalogue-service:travis_$TRAVIS_BUILD_NUMBER  # have to pull locally in order to tag as a release 
docker tag $DOCKER_USERNAME/catalogue-service:travis_$TRAVIS_BUILD_NUMBER $DOCKER_USERNAME/catalogue-service:release_$TRAVIS_BUILD_NUMBER
docker push $DOCKER_USERNAME/catalogue-service:release_$TRAVIS_BUILD_NUMBER
docker tag $DOCKER_USERNAME/catalogue-service:travis_$TRAVIS_BUILD_NUMBER $DOCKER_USERNAME/catalogue-service:latest
docker push $DOCKER_USERNAME/catalogue-service:latest
