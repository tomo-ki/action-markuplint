#!/bin/sh
set -e

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

if ! type markuplint > /dev/null 2>&1; then
  echo '::group:: Running `npm install` to install markuplint ...'
  npm install
  echo '::endgroup::'
fi

echo '::group:: Running markuplint with reviewdog 🐶 ...'
npx "markuplint -f JSON "${INPUT_MARKUPLINT_FLAGS:-'.'}"" \
  | node $GITHUB_ACTION_PATH/markuplint-formatter-rdjson/index.js \
  | reviewdog -f=rdjson \
      -name="markuplint" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

reviewdog_rc=$?
echo '::endgroup::'
exit $reviewdog_rc
