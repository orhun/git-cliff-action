#!/bin/bash -l
set -uxo pipefail

# Avoid file expansion when passing parameters like with '*'
set -o noglob

OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}

# Create the output directory
mkdir -p "$(dirname $OUTPUT)"

# Separate arguments before passing them to git-cliff command
args=$(echo "$@" | xargs)

# Execute git-cliff
cp -r . /tmp/gitdir
mv /tmp/gitdir app
cd app
GIT_CLIFF_OUTPUT="$OUTPUT" git-cliff $args
exit_code=$?

# Output to console
cat "$OUTPUT"

# Set output file
echo "::set-output name=changelog::$OUTPUT"

# Pass exit code to the next step
echo "::set-output name=exit_code::$exit_code"
