#!/usr/bin/env bash

VERSIONS=("4.2.0.0")
CWD=$(dirname $0)

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
chmod +x "${CWD}/build-dataserver.sh"

for DATASERVER_VERSION in "${VERSIONS[@]}"
do
  :

  "${CWD}/build-dataserver.sh" "$DATASERVER_VERSION"
done
