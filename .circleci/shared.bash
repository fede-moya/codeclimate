#!/bin/bash

set -exuo pipefail

VERSION=`cat VERSION`

function install_hub() {
    sudo apt update && sudo apt install -y git wget
    url="$(wget -qO- https://api.github.com/repos/github/hub/releases/latest | tr '"' '\n' | grep '.*/download/.*/hub-linux-amd64-.*.tgz')"
    wget -qO- "$url" | sudo tar -xzvf- -C /usr/bin --strip-components=2 --wildcards "*/bin/hub"
}

function login_to_dockerhub() {
  set +x
  docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
  set -x
}

function login_to_rubygems() {
  mkdir -p $HOME/.gem
  touch $HOME/.gem/credentials
  chmod 0600 $HOME/.gem/credentials
  printf -- "---\n:rubygems_api_key: ${GEM_HOST_API_KEY}\n" > $HOME/.gem/credentials
}

function tag_version() {
  ARTIFACTS_OUTPUT=artifacts.tar.gz
  tar -c -f ${ARTIFACTS_OUTPUT} *.gem
  GITHUB_TOKEN=${GITHUB_TOKEN} hub release create -a ${ARTIFACTS_OUTPUT} -m "v${VERSION}" ${VERSION}
}

function upload_docker_images() {
  docker build --rm --tag codeclimate/codeclimate .
  docker push codeclimate/codeclimate:latest
  docker tag codeclimate/codeclimate "codeclimate/codeclimate:$VERSION"
  docker push "codeclimate/codeclimate:$VERSION"
}

function publish_new_version() {
  set +x
  # Build and push gem
  gem build *.gemspec
  gem push *.gem

  # Create gh tag
  tag_version

  # Push docker images
  #upload_docker_images

  set -x
}
