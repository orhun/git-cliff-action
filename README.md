# git-cliff changelog generator action

This action generates a changelog based on your Git history using [git-cliff](https://github.com/orhun/git-cliff), on the fly!

## Usage

### Inputs

* `args`: Arguments to pass to git-cliff. Default `"-v"`

### Outputs

* `changelog`: The generated changelog.

### Examples

```
- name: Changelog Generator
  uses: orhun/git-cliff-action@v1
  with:
    args: --verbose
```

## Credits

This action is based on [lycheeverse/lychee-action](https://github.com/lycheeverse/lychee-action) and uses [git-cliff](https://github.com/orhun/git-cliff).

## License

GNU General Public License ([v3.0](https://www.gnu.org/licenses/gpl.txt))

## Copyright

Copyright © 2021, [Orhun Parmaksız](mailto:orhunparmaksiz@gmail.com)
