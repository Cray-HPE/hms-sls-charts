#! /usr/bin/env bash

set -xeo pipefail

YQ=/Users/rysjostran/Downloads/yq_darwin_amd64

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    echo "Warning: Chart base path not provided, , defaulting to ./charts"
    CHARTS_BASE=./charts
fi

if [[ -z "$CT_CONFIG" ]]; then
    echo "Warning: CT_CONFIG enviroment variable is not set, defaulting to ct.yaml"
    CT_CONFIG="ct.yaml"
fi

echo "Orginial chart testing configuration"
cat $CT_CONFIG

for CHART_VERSION_PATH in $CHARTS_BASE/v*; do
    echo "Adding chart version dir ${CHART_VERSION_PATH}"
    export CHART_VERSION_PATH="$CHART_VERSION_PATH"
    $YQ eval --inplace -P '.chart-dirs |= . + [env(CHART_VERSION_PATH)]' "$CT_CONFIG"
done

echo "Customized chart testing configuration"
cat $CT_CONFIG