#!/bin/bash -l
set -uxo pipefail

OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}

# Create the output directory
mkdir -p "$(dirname $OUTPUT)"

# Execute git-cliff
GIT_CLIFF_OUTPUT="$OUTPUT" git-cliff $@
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
