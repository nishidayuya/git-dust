require "tmpdir"
require "pathname"
require "git"

require "coveralls"
Coveralls.wear!

require "git/dust"

TOP_PATH = Pathname(__dir__).parent.expand_path
BIN_PATH = TOP_PATH + "bin"
LIB_PATH = TOP_PATH + "lib"

# compatibility
if !Pathname.public_method_defined?(:write)
  class Pathname
    def write(*args)
      open("w") do |f|
        f.write(*args)
      end
    end
  end
end
