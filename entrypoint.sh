#!/bin/bash -l
set -uxo pipefail

CHANGELOG_OUT=${CHANGELOG_OUT:="git-cliff/CHANGELOG.md"}

# Create the output directory
mkdir -p "$(dirname $CHANGELOG_OUT)"

# Execute git-cliff
git-cliff "$@" > "$CHANGELOG_OUT"
exit_code=$?
changelog=$(cat "$CHANGELOG_OUT")

# Output to console
echo "$changelog"

# Set output
echo "::set-output name=changelog::$changelog"

# Pass exit code to the next step
echo ::set-output name=exit_code::$exit_code
