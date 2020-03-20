#!/usr/bin/env bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euov pipefail

# Check presence of environment variables
TRAVIS_BUILD_NUMBER="${TRAVIS_BUILD_NUMBER:-0}"

# Create a Docker image and tag it as 'travis_<build number>'
buildTag=travis_$TRAVIS_BUILD_NUMBER # We use a temporary build number for tagging, since this is a transient artefact

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker pull eoepca/template-service:${buildTag}  # have to pull locally in order to tag as a release

# Tag and push as a Release following the SemVer approach, e.g. 0.1.1-Alpha
docker tag eoepca/template-service:${buildTag} eoepca/template-service:release_${TRAVIS_TAG} # This recovers the GitHub release/tag number
docker push eoepca/template-service:release_${TRAVIS_TAG}

# Tag and push as `latest`
docker tag eoepca/template-service:${buildTag} eoepca/template-service:latest
docker push eoepca/template-service:latest
