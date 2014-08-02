require "tmpdir"
require "pathname"
require "git"

# for coverage tools
require "simplecov"
if ENV["TRAVIS"]
  require "coveralls"
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end
SimpleCov.start if ENV["COVERAGE"] || ENV["TRAVIS"]

require "git/dust"

TOP_PATH = Pathname(__dir__).parent.expand_path
BIN_PATH = TOP_PATH + "bin"
LIB_PATH = TOP_PATH + "lib"

if !Pathname.public_method_defined?(:write)
  # For 2.0.x compatibility.
  class Pathname
    def write(*args)
      open("w") do |f|
        f.write(*args)
      end
    end
  end
end
