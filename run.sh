#!/bin/bash

set -uxo pipefail

# Avoid file expansion when passing parameters like with '*'
set -o noglob

# Set up working directory
owner=$(stat -c "%u:%g" .)
chown -R "$(id -u)" .

# Create the output directory
OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}
mkdir -p "$(dirname $OUTPUT)"

# Separate arguments before passing them to git-cliff command
args=$(echo "$@" | xargs)

# Execute git-cliff
GIT_CLIFF_OUTPUT="$OUTPUT" ./bin/git-cliff $args
exit_code=$?

# Retrieve context
CONTEXT="$(mktemp)"
GIT_CLIFF_OUTPUT="$CONTEXT" ./bin/git-cliff $args --context

# Output to console
cat "$OUTPUT"

# Revert permissions
chown -R "$owner" .

# Set the changelog content
echo "content<<EOF" >>$GITHUB_OUTPUT
cat "$OUTPUT" >>$GITHUB_OUTPUT
echo "EOF" >>$GITHUB_OUTPUT

# Set output file
echo "changelog=$OUTPUT" >>$GITHUB_OUTPUT

# Set the version output to the version of the latest release
echo "version=$(jq -r '.[0].version' $CONTEXT)" >>$GITHUB_OUTPUT

# Pass exit code to the next step
echo "exit_code=$exit_code" >>$GITHUB_OUTPUT