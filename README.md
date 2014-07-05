# git dust

A Git sub command for Dust Commits Workflow.

## Installation

Depenedencies:
* git
* Ruby

Install standalone version:
```sh
$ curl https://raw.githubusercontent.com/nishidayuya/git-dust/master/lib/git-dust.rb > path-environment-directory/git-dust
$ chmod a+x path-environment-directory/git-dust
```

## Usage

To create many dust commits and squash them:
```sh
$ git add foo.txt
$ git dust commit
<commit foo.txt with commit message "git dust commit.">
$ git dust commit -a
<commit modified files with commit message "git dust commit.">
...
$ git dust fix
<squash dust commits and open editor to write commit message>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
