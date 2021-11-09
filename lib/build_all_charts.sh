#! /usr/bin/env bash
set -eo pipefail

SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    "Error: Chart base path not provided"
    exit 1
fi

BUILD_TYPE="stable"
if [[ -n "$UNSTABLE_BUILD_SUFFIX" ]]; then
    BUILD_TYPE="unstable"
fi

for CHART_PATH in $CHARTS_BASE/v*/*; do
    echo
    echo "----------------------------------------"
    echo "Building $CHART_PATH"
    echo "----------------------------------------"
    echo "Build type:              $BUILD_TYPE"
    echo

    ${SCRIPT_DIR}/build_chart.sh "${CHART_PATH}"
done