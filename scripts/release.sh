#!/usr/bin/env bash

set -e
[[ "${DEBUG}" ]] && set -x

bump_version() {
  if [[ $# -lt 1 ]]; then
    die "Usage: ${ROOT_SCRIPT_PATH} ${FUNCNAME[0]} version"
  fi

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${bin}/.."

local VERSION
local NEW_VERSION=${1:-}
VERSION=$(cat "${REPO_DIR}"/VERSION.txt)



echo "Bumping VERSION.txt from ${VERSION} to ${NEW_VERSION}"
git checkout -b "release-${NEW_VERSION}"
printf '%s' "${NEW_VERSION}" >"${REPO_DIR}"/VERSION.txt
printf '%s' "${VERSION}" >"${REPO_DIR}"/PREVIOUS-VERSION.txt

git add "${REPO_DIR}"/VERSION.txt
git add "${REPO_DIR}"/PREVIOUS-VERSION.txt
git add "${REPO_DIR}"/docs/latest
git add "${REPO_DIR}"/docs/"${NEW_VERSION}"
git commit -vam "Bump version to ${NEW_VERSION}"

echo 'Creating release'
echo '# Changelog:' > release.md
git log --pretty=oneline "${VERSION}..master" | awk '{$1=""; if(NR>1) print "-" $0}' >> release.md
echo >> release.md

gh release create "$NEW_VERSION" --notes-file release.md
rm release.md