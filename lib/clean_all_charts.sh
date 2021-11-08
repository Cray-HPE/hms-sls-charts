#! /usr/bin/env bash
set -eo pipefail

SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    "Error: Chart base path not provided"
    exit 1
fi

for CHART_PATH in $CHARTS_BASE/v*/*; do
    echo "Cleaning chart: ${CHART_PATH}"
    rm -rvf ${CHART_PATH}/charts
done