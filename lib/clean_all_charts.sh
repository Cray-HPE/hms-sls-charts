#! /usr/bin/env bash
set -xeo pipefail

SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

CHART_NAME=$1
if [[ -z "$CHART_NAME" ]]; then
    "Error: Chart name path not provided"
    exit 1
fi

for CHART_PATH in $CHART_NAME/*; do
    echo "Cleaning chart: ${CHART_PATH}"
    rm -rvf ${CHART_PATH}/charts
done