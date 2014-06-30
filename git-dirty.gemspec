# coding: utf-8

require "pathname"
lib = Pathname(__dir__) + "lib"
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib.to_s)
require "git-dirty"

Gem::Specification.new do |spec|
  spec.name          = "git-dirty"
  spec.version       = Git::Dirty::VERSION
  spec.authors       = ["Yuya.Nishida."]
  spec.email         = ["yuya@j96.org"]
  spec.summary       = "git-dirty is a git sub command for dirty commiting flow"
  spec.homepage      = "https://github.com/nishidayuya/git-dirty"
  spec.license       = "X11"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
