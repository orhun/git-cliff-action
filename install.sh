#!/bin/bash

if [[ -n "$DEBUG" ]]; then
    set -x
fi

set -uo pipefail

case "${RUNNER_OS}" in
    macOS)   OS=apple-darwin ;;
    Windows) OS=pc-windows-msvc ;;
    *)       OS=unknown-linux-gnu ;;
esac
case "${RUNNER_ARCH}" in
    ARM64) ARCH=aarch64 ;;
    ARM)   ARCH=pc-windows-msvc ;;
    X86)   ARCH=i686 ;;
    *)     ARCH=x86_64 ;;
esac

RELEASE_URL='https://api.github.com/repos/orhun/git-cliff/releases/latest'
if [[ "${VERSION}" != 'latest' ]]; then
    RELEASE_URL="https://api.github.com/repos/orhun/git-cliff/releases/tags/${VERSION}"
fi
echo "Downloading git-cliff ${VERSION} from ${RELEASE_URL}"

# Caching is disabled in order not to receive stale responses from Varnish cache fronting GitHub API.
if [[ -z "${GITHUB_API_TOKEN}" ]]; then
    RELEASE_INFO="$(curl --silent --show-error --fail \
        --header 'Cache-Control: no-cache, must-revalidate' \
        "${RELEASE_URL}")"
else
    # Although releases endpoint is available without authentication, the current github.token is still passed
    # in order to increase the limit of 60 requests per hour per IP address to a higher value that's also counted
    # per GitHub account.
    RELEASE_INFO="$(curl --silent --show-error --fail \
        --header "authorization: Bearer ${GITHUB_API_TOKEN}" \
        --header 'Cache-Control: no-cache, must-revalidate' \
        "${RELEASE_URL}")"
fi

TAG_NAME="$(echo "${RELEASE_INFO}" | jq --raw-output ".tag_name")"
TARGET="git-cliff-${TAG_NAME:1}-${ARCH}-${OS}.tar.gz"
LOCATION="$(echo "${RELEASE_INFO}" |
    jq --raw-output ".assets[].browser_download_url" |
    grep "${TARGET}$")"
echo "Found release: ${LOCATION}"

# Create bin directory
mkdir -p ./bin

# Skip downloading release if downloaded already, e.g. when the action is used multiple times.
if [[ ! -e "$TARGET" ]]; then
    echo "Downloading ${TARGET}..."
    curl --silent --show-error --fail --location --output "$TARGET" "$LOCATION"
    tar -xf "$TARGET"
    mv git-cliff-${TAG_NAME:1}/git-cliff ./bin/git-cliff
else
    echo "Using cached git-cliff binary."
fi

echo "git-cliff is ready to use!"
