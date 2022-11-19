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
echo "changelog=$OUTPUT" >> $GITHUB_OUTPUT

# Set the changelog content
echo "content<<EOF" >> $GITHUB_OUTPUT
cat "$OUTPUT" >> $GITHUB_OUTPUT
echo "EOF"

# Pass exit code to the next step
echo "exit_code=$exit_code" >> $GITHUB_OUTPUT
