#!/bin/bash

set -uxo pipefail

# Avoid file expansion when passing parameters like with '*'
set -o noglob

GIT_CLIFF_BIN='git-cliff'

if [[ "${RUNNER_OS}" == 'Windows' ]]; then
    GIT_CLIFF_BIN="${GIT_CLIFF_BIN}.exe"
fi

GIT_CLIFF_PATH="$RUNNER_TEMP/git-cliff/bin/$GIT_CLIFF_BIN"

# Set up working directory
owner=$(stat -c "%u:%g" .)
chown -R "$(id -u)" .

# Create the output directory
OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}
mkdir -p "$(dirname "$OUTPUT")"

# Separate arguments before passing them to git-cliff command
args=$(echo "$@" | xargs)

# Execute git-cliff
GIT_CLIFF_OUTPUT="$OUTPUT" "$GIT_CLIFF_PATH" "$args"
exit_code=$?

# Retrieve context
CONTEXT="$(mktemp)"
GIT_CLIFF_OUTPUT="$CONTEXT" "$GIT_CLIFF_PATH" --context "$args"

# Revert permissions
chown -R "$owner" .

# Set the changelog content (max: 50MB)
FILESIZE=$(stat -c%s "$OUTPUT")
MAXSIZE=$((40 * 1024 * 1024))
if [ "$FILESIZE" -le "$MAXSIZE" ]; then
    {
        echo "content<<EOF"
        cat "$OUTPUT"
        echo "EOF"
    } >>"$GITHUB_OUTPUT"
    cat "$OUTPUT"
fi

# Set output variables in a single block
{
    echo "changelog=$OUTPUT"
    echo "version=$(jq -r '.[0].version' "$CONTEXT")" # Set the version output to the version of the latest release
    echo "exit_code=$exit_code" # Pass exit code to the next step
} >>"$GITHUB_OUTPUT"
