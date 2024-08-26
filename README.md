# [git-cliff](https://github.com/orhun/git-cliff) action ⛰️

This action generates a changelog based on your Git history using [git-cliff](https://github.com/orhun/git-cliff) on the fly!

## Usage

### Input variables

- `version`: `git-cliff` version to use (Default: `"latest"`)
- `config`: Path of the configuration file. (Default: `"cliff.toml"`)
- `args`: [Arguments](https://github.com/orhun/git-cliff#usage) to pass to git-cliff. (Default: `"-v"`)

### Output variables

- `changelog`: Output file that contains the generated changelog.
- `content`: Content of the changelog.
- `version`: Version of the latest release.

### Environment variables

- `OUTPUT`: Output file. (Default: `"git-cliff/CHANGELOG.md"`)

> [!IMPORTANT]
> Check out the entire history via `fetch-depth: 0` before running this action.
>
> ```yaml
> - name: Checkout
>   uses: actions/checkout@v4
>   with:
>     fetch-depth: 0
> ```
>
> Otherwise, you might end up getting empty changelogs or `git ref` errors depending on arguments passed to `git-cliff`.

### Examples

#### Simple

The following example fetches the whole Git history (`fetch-depth: 0`), generates a changelog in `./CHANGELOG.md`, and prints it out.

```yml
jobs:
  changelog:
    name: Generate changelog
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Generate a changelog
        uses: orhun/git-cliff-action@v4
        id: git-cliff
        with:
          version: latest
          config: cliff.toml
          args: --verbose
        env:
          OUTPUT: CHANGELOG.md

      - name: Print the changelog
        run: cat "${{ steps.git-cliff.outputs.changelog }}"
```

#### Advanced

The following example generates a changelog for the latest pushed tag and sets it as the body of the release.

It uses [svenstaro/upload-release-action](https://github.com/svenstaro/upload-release-action) for uploading the release assets.

```yml
jobs:
  changelog:
    name: Generate changelog
    runs-on: ubuntu-latest
    outputs:
      release_body: ${{ steps.git-cliff.outputs.content }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Generate a changelog
        uses: orhun/git-cliff-action@v4
        id: git-cliff
        with:
          config: cliff.toml
          args: -vv --latest --strip header
        env:
          OUTPUT: CHANGES.md
          GITHUB_REPO: ${{ github.repository }}

      # use release body in the same job
      - name: Upload the binary releases
        uses: svenstaro/upload-release-action@v2
        with:
          file: binary_release.zip
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          tag: ${{ github.ref }}
          body: ${{ steps.git-cliff.outputs.content }}

  # use release body in another job
  upload:
    name: Upload the release
    needs: changelog
    runs-on: ubuntu-latest
    steps:
      - name: Upload the binary releases
        uses: svenstaro/upload-release-action@v2
        with:
          file: binary_release.zip
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          tag: ${{ github.ref }}
          body: ${{ needs.changelog.outputs.release_body }}
```

#### Committing the changelog

You can use this action as follows if you want to generate a changelog and commit it to the repository:

```yml
jobs:
  changelog:
    name: Generate changelog
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Generate a changelog
        uses: orhun/git-cliff-action@v4
        with:
          config: cliff.toml
          args: --verbose
        env:
          OUTPUT: CHANGELOG.md
          GITHUB_REPO: ${{ github.repository }}

      - name: Commit
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email 'github-actions[bot]@users.noreply.github.com'
          set +e
          git add CHANGELOG.md
          git commit -m "Update changelog"
          git push https://${{ secrets.GITHUB_TOKEN }}@github.com/${GITHUB_REPOSITORY}.git <branch>
```

Please note that you need to change the `<branch>` to the branch name that you want to push.

## License

GNU General Public License ([v3.0](https://www.gnu.org/licenses/gpl.txt))

## Copyright

Copyright © 2021-2023, [Orhun Parmaksız](mailto:orhunparmaksiz@gmail.com)
