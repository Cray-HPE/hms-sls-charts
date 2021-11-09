#! /usr/bin/env bash
set -eo pipefail

TARGET_BRANCH=$1
if [[ -z "$TARGET_BRANCH" ]]; then
    echo  "Error: Target branch not provided"
    exit 1
fi


echo "Target branch: $TARGET_BRANCH" 1>&2;

# First, get the lastest tags from the upstream repo
echo "Fetching tags" 1>&2;
git fetch --tags > /dev/null

# Second idenfiy any charts that have changed between this branch and the target branch
CHANGED_CHARTS=$(ct list-changed --target-branch "$TARGET_BRANCH")

for chart_path in $CHANGED_CHARTS; do
    echo "Checking changed chart: $chart_path" 1>&2;
    chart_yaml_path="$chart_path/Chart.yaml"
    if [[ ! -f "$chart_yaml_path" ]]; then
        echo "Warning: $chart_yaml_path does not exist, skipping potential chart: $chart_path"
    fi

    chart_name=$(yq e .name "$chart_yaml_path")
    chart_version=$(yq e .version "$chart_yaml_path")
    expected_git_tag="$chart_name-$chart_version"
    expected_git_tag_exists="false"

    if git rev-parse -q --verify "refs/tags/$expected_git_tag" > /dev/null; then
        expected_git_tag_exists="true"
    fi

    jq -n -c \
        --arg PATH "$chart_path" \
        --arg NAME "$chart_name" \
        --arg VERSION "$chart_version" \
        --arg EXPECTED_GIT_TAG "$expected_git_tag" \
        --argjson EXPECTED_GIT_TAG_EXISTS "$expected_git_tag_exists" \
        '{Path: $PATH, Name: $NAME, Version: $VERSION, ExpectedGitTag: $EXPECTED_GIT_TAG, ExpectedGitTagExists: $EXPECTED_GIT_TAG_EXISTS}'
done
