#!/bin/bash

set -uxo pipefail

# Avoid file expansion when passing parameters like with '*'
set -o noglob

GIT_CLIFF_BIN='git-cliff'

if [[ "${RUNNER_OS}" == 'Windows' ]]; then
    GIT_CLIFF_BIN="${GIT_CLIFF_BIN}.exe"
fi

# Set up working directory
owner=$(stat -c "%u:%g" .)
chown -R "$(id -u)" .

# Create the output directory
OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}
mkdir -p "$(dirname $OUTPUT)"

# Separate arguments before passing them to git-cliff command
args=$(echo "$@" | xargs)

# Execute git-cliff
GIT_CLIFF_OUTPUT="$OUTPUT" ./bin/${GIT_CLIFF_BIN} $args
exit_code=$?

# Retrieve context
CONTEXT="$(mktemp)"
GIT_CLIFF_OUTPUT="$CONTEXT" ./bin/${GIT_CLIFF_BIN} $args --context

# Revert permissions
chown -R "$owner" .

# Set the changelog content (max: 50MB)
FILESIZE=$(stat -c%s "$OUTPUT")
MAXSIZE=$((40 * 1024 * 1024))
if [ "$FILESIZE" -le "$MAXSIZE" ]; then
    echo "content<<EOF" >>$GITHUB_OUTPUT
    cat "$OUTPUT" >>$GITHUB_OUTPUT
    echo "EOF" >>$GITHUB_OUTPUT
    cat "$OUTPUT"
fi

# Set output file
echo "changelog=$OUTPUT" >>$GITHUB_OUTPUT

# Set the version output to the version of the latest release
echo "version=$(jq -r '.[0].version' $CONTEXT)" >>$GITHUB_OUTPUT

# Pass exit code to the next step
echo "exit_code=$exit_code" >>$GITHUB_OUTPUT
