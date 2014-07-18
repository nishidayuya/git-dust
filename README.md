# git dust

A Git sub command for Dust Commits Workflow.

[![Gem Version](https://badge.fury.io/rb/git-dust.svg)](http://badge.fury.io/rb/git-dust)
[![Dependency Status](https://gemnasium.com/nishidayuya/git-dust.svg)](https://gemnasium.com/nishidayuya/git-dust)
[![Build Status](https://travis-ci.org/nishidayuya/git-dust.svg?branch=master)](https://travis-ci.org/nishidayuya/git-dust)
[![Coverage Status](https://img.shields.io/coveralls/nishidayuya/git-dust.svg)](https://coveralls.io/r/nishidayuya/git-dust)

## Installation

Depenedencies:
* git
* Ruby

Install via RubyGems:
```sh
$ gem install git-dust
```

Install standalone version:
```sh
$ curl https://raw.githubusercontent.com/nishidayuya/git-dust/master/lib/git/dust.rb \
| sed -e 's/^# FOR STANDALONE: //' \
> path-environment-directory/git-dust
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

## News

* 0.0.0: 2014-07-12 first release.
  * "git dust commit" and "git dust fix".

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
