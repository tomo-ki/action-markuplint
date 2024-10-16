# GitHub Action: Run markuplint with reviewdog

This action runs [markuplint](https://github.com/markuplint/markuplint) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.GITHUB_TOKEN }}`

### `workdir`

**Optional**. Working directory relative to the root directory. Default is `.`.

### `markuplint_flags`

**Optional**. Additional markuplint flags

### `markuplint_config`

**Optional**. markuplint config file

### `level`

**Optional**. Report level for reviewdog [info,warning,error]. It's same as `-level` flag of reviewdog.

### `reporter`

**Optional**. Reporter of reviewdog command [github-pr-check,github-pr-review,github-check].
Default is github-pr-check.

### `filter_mode`

**Optional**. Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
Default is added.

### `fail_on_error`

**Optional**. Exit code for reviewdog when errors are found [true,false]
Default is `false`.

### `reviewdog_flags`

**Optional**. Additional reviewdog flags

## Example usage

```yaml
name: markuplint
on: [pull_request]
jobs:
  markuplint:
    name: runner / markuplint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: reviewdog/action-markuplint@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review