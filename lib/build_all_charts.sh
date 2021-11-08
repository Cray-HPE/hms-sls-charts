#! /usr/bin/env bash
set -xeo pipefail

SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    "Error: Chart base path not provided"
    exit 1
fi

for CHART_PATH in $CHARTS_BASE/v*/*; do
    echo "Building chart: $CHART_PATH"
    ${SCRIPT_DIR}/build_chart.sh "${CHART_PATH}"
done