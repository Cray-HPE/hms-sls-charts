#! /usr/bin/env bash

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    "Error: Chart base path not provided"
    exit 1
fi

for CHART_PATH in $CHARTS_BASE/v*/*; do
    echo "Cleaning chart: ${CHART_PATH}"
    
done