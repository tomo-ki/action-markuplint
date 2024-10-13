#!/bin/bash

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo "::group::🐶 Installing reviewdog..."
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b ./bin
echo "::endgroup::"

echo "::group:: Installing markuplint and formatter..."
npm install markuplint @markuplint/config-presets
npm install --save-dev ./markuplint-formatter-rdjson
echo "::endgroup::"

echo "::group:: Running markuplint with reviewdog..."
markuplint ${INPUT_MARKUPLINT_FLAGS} \
  | ./bin/reviewdog \
      -f=rdjson \
      -name="markuplint" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}"

reviewdog_rc=$?
echo "::endgroup::"
exit $reviewdog_rc