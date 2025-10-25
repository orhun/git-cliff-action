#!/bin/bash

if [[ -n "$DEBUG" ]]; then
    set -x
fi

set -uo pipefail

# Avoid file expansion when passing parameters like with '*'
set -o noglob

GIT_CLIFF_BIN='git-cliff'

if [[ "${RUNNER_OS}" == 'Windows' ]]; then
    GIT_CLIFF_BIN="${GIT_CLIFF_BIN}.exe"
fi

GIT_CLIFF_PATH="$RUNNER_TEMP/git-cliff/bin/$GIT_CLIFF_BIN"

# On Darwin, BSD stat is the default
# otherwise is GNU stat
if [[ "${RUNNER_OS}" == "macOS" ]]; then
    stat_cmd=(stat -f)
else
    stat_cmd=(stat -c)
fi

# Set up working directory
owner=$("${stat_cmd}" "%u:%g" .)
chown -R "$(id -u)" .

# Create the output directory
OUTPUT=${OUTPUT:="git-cliff/CHANGELOG.md"}
mkdir -p "$(dirname $OUTPUT)"

args=()
take_next=
for arg in "$@"; do
    case "$arg" in
    -o | --output)
        take_next=1 # next argument is the output file
        ;;
    -o=* | --output=*)
        OUTPUT="${arg#*=}" # consume the output file directly
        ;;
    *)
        if [ -n "$take_next" ]; then
            OUTPUT="$arg"
            take_next=
        else
            args+=("$arg") # keep only non-output args
        fi
        ;;
    esac
done

# Execute git-cliff
GIT_CLIFF_OUTPUT="$OUTPUT" "$GIT_CLIFF_PATH" "${args[@]}"
exit_code=$?

# Retrieve context
CONTEXT="$(mktemp)"
GIT_CLIFF_OUTPUT="$CONTEXT" "$GIT_CLIFF_PATH" --context "${args[@]}"

# Revert permissions
chown -R "$owner" .

# Set the changelog content (max: 50MB)
FILESIZE=$("${stat_cmd}" %s "$OUTPUT")
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

# Exit with git-cliff exit_code
exit $exit_code
