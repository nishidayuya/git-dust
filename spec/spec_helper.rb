require "tmpdir"
require "pathname"
require "git"

require "git/dust"

TOP_PATH = Pathname(__dir__).parent.expand_path
BIN_PATH = TOP_PATH + "bin"
