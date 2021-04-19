#!/bin/bash

set -exuo pipefail

function login_to_dockerhub() {
  set +x
  docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
  set -x
}

function install_hub() {
    sudo apt update && sudo apt install -y git wget
    url="$(wget -qO- https://api.github.com/repos/github/hub/releases/latest | tr '"' '\n' | grep '.*/download/.*/hub-linux-amd64-.*.tgz')"
    wget -qO- "$url" | sudo tar -xzvf- -C /usr/bin --strip-components=2 --wildcards "*/bin/hub"
}

#function install_cc_test_reporter() {
#  local version="${1:-latest}"
#
#  curl -L -o "/tmp/cc-test-reporter" "https://codeclimate.com/downloads/test-reporter/test-reporter-$version-linux-amd64"
#  sudo mv /tmp/cc-test-reporter /usr/bin
#  sudo chmod +x /usr/bin/cc-test-reporter
#}

#function install_aws_cli() {
#  sudo pip install --quiet --upgrade awscli
#  aws configure set default.region us-east-1
#  aws configure set default.s3.max_concurrent_requests 20
#}


#function login_to_replicated() {
#  set +x
#  docker login --username "$REPLICATED_EMAIL" --password "$REPLICATED_PASSWORD" registry.replicated.com
#  set -x
#}

#function login_to_gcr() {
#  set +x
#  docker login --username _json_key --password "$GCR_JSON_KEY" us.gcr.io
#  set -x
#}

#function cp_test_coverage() {
#  docker cp "test-workflow-${CIRCLE_WORKFLOW_ID}-node-${CIRCLE_NODE_INDEX}":/app/coverage coverage
#
#  cc-test-reporter format-coverage --input-type simplecov --output "./coverage/codeclimate.$CIRCLE_NODE_INDEX.json" --prefix "/app"
#  mv coverage/.resultset.json "./coverage/.resultset.$CIRCLE_NODE_INDEX.json"
#  printf "%s\n" "$CIRCLE_NODE_TOTAL" > ./coverage/node-total
#}

#function report_test_coverage() {
#  cc-test-reporter sum-coverage coverage/codeclimate.*.json --parts "$(cat ./coverage/node-total)"
#
#  cc-test-reporter upload-coverage || echo "report coverage skipped"
#}

#function pull_images() {
#  docker pull "$IMAGE_REF"
#  docker pull codeclimate/api
#  docker pull percona/percona-server-mongodb:3.2
#  docker pull redis:2.8
#}
