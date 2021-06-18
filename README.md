# git-cliff changelog generator action

This action generates a changelog based on your Git history using [git-cliff](https://github.com/orhun/git-cliff), on the fly!

## Usage

### Inputs

- `config`: Path of the configuration file. Default: `"cliff.toml"`
- `args`: Arguments to pass to git-cliff. Default: `"-v"`

### Outputs

- `changelog`: Output file that contains the generated changelog.

### Environment

- `OUTPUT`: Output file. Default: `"git-cliff/CHANGELOG.md"`

### Examples

```yml
- name: Checkout
  uses: actions/checkout@v2
  with:
    fetch-depth: 0
- name: Generate a changelog
  uses: orhun/git-cliff-action@v1
  id: git-cliff
  with:
    config: cliff.toml
    args: --verbose
  env:
    OUTPUT: CHANGELOG.md
- name: Print the changelog
  run: cat "${{ steps.git-cliff.outputs.changelog }}"
```

## Credits

This action is based on [lycheeverse/lychee-action](https://github.com/lycheeverse/lychee-action) and uses [git-cliff](https://github.com/orhun/git-cliff).

## License

GNU General Public License ([v3.0](https://www.gnu.org/licenses/gpl.txt))

## Copyright

Copyright © 2021, [Orhun Parmaksız](mailto:orhunparmaksiz@gmail.com)
