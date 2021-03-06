#! /usr/bin/env ruby

require "open3"
require "pathname"

# A namespace for Git::Dust.
module Git
end

# Main class.
class Git::Dust
  def self.help(_args = [])
    $stderr.puts(<<EOS)
#{File.basename($PROGRAM_NAME)} <command> [<args>]

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
      $stderr.puts("sub command not found: sub_command=<#{command}>")
      $stderr.puts
      help
      exit(1)
    end
  end

  def self.commit(args)
    run_command(*%w(git commit -m), COMMIT_MESSAGE, *args)
  end

  def self.fix(_args)
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
        next if /\A\s*#/.match(l)
        output << l
        break
      end
      lines.each do |l| # change "pick" to "fixup"
        output << l.sub(/\Apick/, "fixup")
      end
    end
    rebase_todo_path.open("w") do |f|
      f.write(output.join)
    end
  end

  private

  COMMIT_MESSAGE = "git dust commit.".freeze

  def self.run_command(*args)
    fail "failed: args=<#{args.inspect}>" if !system(*args)
  end

  def self.find_non_dust_commit
    Open3.popen2("git log --format=oneline") do |_stdin, stdout, _wait_thread|
      stdout.each_line.each do |line|
        sha1, subject = line.chomp.split(" ", 2)
        return sha1 if COMMIT_MESSAGE != subject
      end
    end
    fail "non dust commit is not exist."
  end
end

# FOR STANDALONE: Git::Dust.run(ARGV)
