#!/bin/bash -l
set -uxo pipefail

# Avoid file expansion when passing parameters like with '*'
set -o noglob

# Set up working directory
WORKDIR="app"
cp -r . /tmp/gitdir
mv /tmp/gitdir "$WORKDIR"
cd "$WORKDIR" || exit

# Create the output directory
OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}
mkdir -p "$(dirname $OUTPUT)"

# Separate arguments before passing them to git-cliff command
args=$(echo "$@" | xargs)

# Execute git-cliff
GIT_CLIFF_OUTPUT="$OUTPUT" git-cliff $args
exit_code=$?

# Output to console
cat "$OUTPUT"

# Set the changelog content
echo "content<<EOF" >> $GITHUB_OUTPUT
cat "$OUTPUT" >> $GITHUB_OUTPUT
echo "EOF" >> $GITHUB_OUTPUT

# Set output file
OUTPUT="$WORKDIR/$OUTPUT"
echo "changelog=$OUTPUT" >> $GITHUB_OUTPUT

# Pass exit code to the next step
echo "exit_code=$exit_code" >> $GITHUB_OUTPUT
