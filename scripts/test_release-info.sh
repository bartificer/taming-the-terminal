#!/bin/bash

# This is a script that helps test the Python script
# that checks the GitHub Action event and the version

# root dir of this project
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

cd ${DIR}

echo '----------------------------------'
echo
echo "Check scheduled build"
echo
echo "This should produce output with a tag 'nightly.<current date>"
echo
GITHUB_EVENT_NAME='schedule'
python3 ${DIR}/ci/release-info.py $GITHUB_EVENT_NAME
echo

echo '----------------------------------'
echo
echo "Check pushing a tag where the version is consistent with the release.json file"
echo
echo "This should produce output with a version ${version} and a tag v${version}"
echo
version=$(grep 'version' ${DIR}/release.json | cut -d' ' -f2)
GITHUB_EVENT_NAME='push'
GITHUB_REF="refs/tags/v${version}"
python3 ${DIR}/ci/release-info.py $GITHUB_EVENT_NAME
echo

echo '----------------------------------'
echo
echo "Check pushing a tag where the version is different from the release.json file"
echo
echo "This should produce an error message"

version='dummy'
GITHUB_EVENT_NAME='push'
GITHUB_REF="refs/tags/v${version}"
python3 ${DIR}/ci/release-info.py $GITHUB_EVENT_NAME
