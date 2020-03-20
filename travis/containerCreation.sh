#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail

./gradlew shadowJar

# Check presence of environment variables
TRAVIS_BUILD_NUMBER="${TRAVIS_BUILD_NUMBER:-0}"


# Create a Docker image and tag it as 'travis_<build number>'
buildTag=travis_$TRAVIS_BUILD_NUMBER # We use a temporary build number for tagging, since this is a transient artefact

docker build -t eoepca/template-service .
docker tag eoepca/template-service eoepca/template-service:$buildTag # Tags container in EOEPCA repository with buildTag

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker push eoepca/template-service:$buildTag   # defaults to docker hub EOEPCA repository
