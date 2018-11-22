#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail
# Not supported in travis (xenial)
# shopt -s inherit_errexit

# compiles, runs unit tests and packages as a single jar
./gradlew build #--scan -s
#ls -l build/libs

buildTag=travis_${TRAVIS_BRANCH}_$TRAVIS_BUILD_NUMBER

# Create a Docker image and tag it as 'travis_<build number>'
docker build -t eoepca/catalogue-service .
docker tag eoepca/catalogue-service $DOCKER_USERNAME/catalogue-service:$buildTag

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker push $DOCKER_USERNAME/catalogue-service:$buildTag   # defaults to docker hub