#! /usr/bin/env bash
set -eo pipefail

SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

CHARTS_BASE=$1
if [[ -z "$CHARTS_BASE" ]]; then
    "Error: Chart base path not provided"
    exit 1
fi

TARGET_BRANCH=$2
if [[ -z "$TARGET_BRANCH" ]]; then
    echo  "Error: Target branch not provided"
    exit 1
fi

BUILD_TYPE="stable"
if [[ -n "$UNSTABLE_BUILD_SUFFIX" ]]; then
    BUILD_TYPE="unstable"
fi

changed_charts=$(${SCRIPT_DIR}/detect_changed_charts.sh "$TARGET_BRANCH" | jq -r @base64)

for changed_chart in $changed_charts; do
    chart_path=$(echo "$changed_chart" | base64 -d | jq -r .Path)
    expected_git_tag=$(echo "$changed_chart" | base64 -d | jq -r .ExpectedGitTag)
    expected_git_tag_exists=$(echo "$changed_chart" | base64 -d | jq -r .ExpectedGitTagExists)

    echo
    echo "----------------------------------------"
    echo "Building $chart_path"
    echo "----------------------------------------"
    echo "Build type:              $BUILD_TYPE"
    echo "Expected git tag:        $expected_git_tag"
    echo "Expected git tag exists: $expected_git_tag_exists"
    echo

    # For unstable builds, we will build all changed charts as each changed chart will get its own unique version
    if [[ "$BUILD_TYPE" == "stable" ]] && [[ "$expected_git_tag_exists" == "true" ]]; then
        # On stable chart builds refuse to build a chart if its version did not change
        echo "Refusing to build $chart_path as the Git tag $expected_git_tag already exists!"
        continue
    fi

    ${SCRIPT_DIR}/build_chart.sh "${chart_path}"

done