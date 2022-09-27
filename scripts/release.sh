#!/usr/bin/env bash

set -e
[[ "${DEBUG}" ]] && set -x


if [[ $# -lt 1 ]]; then
  echo "Usage: ${0:-} <version>"
  exit 1
fi

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${bin}/.."


NEW_VERSION=${1:-}
VERSION=$(cat "${REPO_DIR}"/VERSION)



echo "Bumping VERSION from ${VERSION} to ${NEW_VERSION}"
printf '%s' "${NEW_VERSION}" >"${REPO_DIR}"/VERSION
printf '%s' "${VERSION}" >"${REPO_DIR}"/PREVIOUS-VERSION

git add "${REPO_DIR}"/VERSION
git add "${REPO_DIR}"/PREVIOUS-VERSION

echo 'Creating release'
echo "# Changelog:" > release.md
git commit -vam "Bump version to ${NEW_VERSION}"
git log --pretty=oneline "${VERSION}..HEAD~" | awk '{$1=""; if(NR>1) print "-" $0}' >> release.md
echo >> release.md

gh release create "$NEW_VERSION" --title "$NEW_VERSION" --notes-file release.md

rm release.md
