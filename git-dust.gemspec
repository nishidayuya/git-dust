# coding: utf-8

require "pathname"
lib = Pathname(__dir__) + "lib"
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib.to_s)
require "git-dust"

Gem::Specification.new do |spec|
  spec.name          = "git-dust"
  spec.version       = Git::Dust::VERSION
  spec.authors       = ["Yuya.Nishida."]
  spec.email         = ["yuya@j96.org"]
  spec.summary       = "A Git sub command for Dust Commits Workflow."
  spec.homepage      = "https://github.com/nishidayuya/git-dust"
  spec.license       = "X11"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
