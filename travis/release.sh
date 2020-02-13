#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker pull $DOCKER_USERNAME/template-service:travis_${TRAVIS_BRANCH}_$TRAVIS_BUILD_NUMBER  # have to pull locally in order to tag as a release

# Tag and push as a Release
docker tag $DOCKER_USERNAME/template-service:travis_${TRAVIS_BRANCH}_$TRAVIS_BUILD_NUMBER $DOCKER_USERNAME/template-service:release_$TRAVIS_TAG
docker push $DOCKER_USERNAME/template-service:release_$TRAVIS_TAG

# Tag and push as `latest`
docker tag $DOCKER_USERNAME/template-service:travis_${TRAVIS_BRANCH}_$TRAVIS_BUILD_NUMBER $DOCKER_USERNAME/template-service:latest
docker push $DOCKER_USERNAME/template-service:latest
