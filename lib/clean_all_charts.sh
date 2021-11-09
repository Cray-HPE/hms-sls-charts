#! /usr/bin/env bash
set -eo pipefail

SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    echo  "Error: Chart base path not provided"
    exit 1
fi

for CHART_PATH in $CHARTS_BASE/v*/*; do
    echo
    echo "----------------------------------------"
    echo "Cleaning chart: ${CHART_PATH}"
    echo "----------------------------------------"
    echo

    rm -rvf ${CHART_PATH}/charts
    rm -rvf ${CHART_PATH}/tmpcharts
done