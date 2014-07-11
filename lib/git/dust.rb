#! /usr/bin/env ruby

require "open3"
require "pathname"

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

module Git
end

class Git::Dust
  def self.help(args = [])
    STDERR.puts(<<EOS)
#{File.basename($0)} <command> [<args>]

git dust commands are:
* commit
EOS
  end

  def self.run(command_and_args)
    command = command_and_args.first || "help"
    command_symbol = command.gsub("-", "_").to_sym
    args = command_and_args[1 .. -1]
    defined_commands = public_methods(false) - %i(allocate new superclass run)
    if defined_commands.include?(command_symbol)
      send(command_symbol, args)
    else
      STDERR.puts("sub command not found: sub_command=<#{command}>")
      STDERR.puts
      help
      exit(1)
    end
  end

  def self.commit(args)
    run_command(*%w(git commit -m), COMMIT_MESSAGE, *args)
  end

  def self.fix(args)
    base_sha1 = find_non_dust_commit
    saved_editor_environment = ENV["GIT_SEQUENCE_EDITOR"]
    begin
      ENV["GIT_SEQUENCE_EDITOR"] = "git dust edit-rebase-commit-list"
      run_command(*%w(git rebase -i), base_sha1)
    ensure
      ENV["GIT_SEQUENCE_EDITOR"] = saved_editor_environment
    end
    run_command(*%w(git reset --soft HEAD^))
    run_command("git commit --edit")
  end

  def self.edit_rebase_commit_list(args)
    output = []
    rebase_todo_path = Pathname(args.first)
    rebase_todo_path.open do |f|
      lines = f.each_line
      lines.each do |l| # write first commit
        if !/\A\s*#/.match(l)
          output << l
          break
        end
      end
      lines.each do |l| # change "pick" to "fixup"
        output << l.sub(/\Apick/, "fixup")
      end
    end
    rebase_todo_path.write(output.join)
  end

  private

  COMMIT_MESSAGE = "git dust commit.".freeze

  def self.run_command(*args)
    if !system(*args)
      raise "failed: args=<#{args.inspect}>"
    end
  end

  def self.find_non_dust_commit
    Open3.popen2("git log --format=oneline") do |stdin, stdout, wait_thread|
      stdout.each_line.each do |line|
        sha1, subject = line.chomp.split(" ", 2)
        return sha1 if COMMIT_MESSAGE != subject
      end
    end
    raise "non dust commit is not exist."
  end
end

if $0 == __FILE__
  Git::Dust.run(ARGV)
end
