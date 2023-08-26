name: Create issue on commit

on: [ push ]

jobs:
  test:   
    runs-on: ubuntu-latest
    steps:
      - id: list-envs
        shell: bash
        run: |
          echo "envs=$(
            curl -L \
            -H 'Accept: application/vnd.github+json' \
            -H 'Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' \
            -H 'X-GitHub-Api-Version: 2022-11-28' \
            https://api.github.com/repos/makramjandar/temp-repo/environments \
            | jq '.environments[].name'
          )" >> $GITHUB_OUTPUT

        - run: echo random-number ${{ steps.list-envs.outputs.envs }}
          shell: bash

