#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail
# Not supported in travis (xenial)
# shopt -s inherit_errexit

# compiles, runs unit tests and packages as a single jar
./gradlew build #--scan -s
#ls -l build/libs

# Create a Docker image and tag it as 'travis_<build number>'
docker build -t eoepca/catalogue-service .
docker tag eoepca/catalogue-service $DOCKER_USERNAME/catalogue-service:travis_$TRAVIS_BUILD_NUMBER

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin