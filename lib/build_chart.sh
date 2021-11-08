#! /usr/bin/env bash
set -xeo pipefail

CHART_PATH=$1
if [[ -z "$CHART_PATH" ]]; then
    "Error: Chart path not path not provided"
    exit 1
fi

helm dep up $CHART_PATH
HELM_PACKAGE_OPTS=""

if [[ -n "$UNSTABLE_BUILD_SUFFIX" ]]; then
    echo "Performing unstable chart build!"
    CHART_VERSION=$(helm show chart ${CHART_PATH} | grep -e '^version:' | sed 's/^version: //g')
    HELM_PACKAGE_OPTS="--version ${CHART_VERSION}-${UNSTABLE_BUILD_SUFFIX}"
fi

helm package $CHART_PATH -d .packaged ${HELM_PACKAGE_OPTS}