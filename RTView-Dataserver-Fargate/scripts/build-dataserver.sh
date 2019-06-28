#!/usr/bin/env bash

set -e

VARIANTS=("" "kafka" "solace")
DATASERVER_VERSION=$1
CWD=$(dirname $0)
BUILD_ROOT="${CWD}/.."

echo "Building v${DATASERVER_VERSION}"

echo "Building history-db"

history_db_tag="${REGISTRY}/rtview-dataserver-history-db:${DATASERVER_VERSION}"

docker build -t "${history_db_tag}" \
  -f "${BUILD_ROOT}/Dockerfile.history-db" \
  --build-arg RTV_DATASERVER_VERSION="${DATASERVER_VERSION}" \
  "$BUILD_ROOT"

docker push "${history_db_tag}"

for DATASERVER_VARIANT in "${VARIANTS[@]}"
do
  :

  if [ -z "$DATASERVER_VARIANT" ]; then
    VARIANT_TAG=""
  else
    VARIANT_TAG="-${DATASERVER_VARIANT}"
  fi

  echo "Building ${DATASERVER_VARIANT} v${DATASERVER_VERSION}"

  echo "Building historian"

  historian_tag="${REGISTRY}/rtview-dataserver-historian:${DATASERVER_VERSION}${VARIANT_TAG}"

  docker build -t "${historian_tag}" \
    -f "${BUILD_ROOT}/Dockerfile.historian" \
    --build-arg RTV_DATASERVER_VERSION="${DATASERVER_VERSION}" \
    --build-arg RTV_DATASERVER_VARIANT="${DATASERVER_VARIANT}" \
    "$BUILD_ROOT"

  docker push "${historian_tag}"

  echo "Building dataserver"

  dataserver_tag="${REGISTRY}/rtview-dataserver:${DATASERVER_VERSION}${VARIANT_TAG}"

  docker build -t "${dataserver_tag}" \
    -f "${BUILD_ROOT}/Dockerfile.dataserver" \
    --build-arg RTV_DATASERVER_VERSION="${DATASERVER_VERSION}" \
    --build-arg RTV_DATASERVER_VARIANT="${DATASERVER_VARIANT}" \
    "$BUILD_ROOT"

  docker push "${dataserver_tag}"
done
