#!/usr/bin/env bash

if [[ ! -z "${PULL_BASE_SHA}" ]]; then
	jx step changelog  --verbose --header-file docs/dev/changelog-header.md --version ${VERSION} --rev ${PULL_BASE_SHA}
fi
