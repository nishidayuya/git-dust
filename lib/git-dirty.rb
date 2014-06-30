#! /usr/bin/env ruby

module Git
end

class Git::Dirty
  VERSION = "0.0.0"

  def self.help
    STDERR.puts(<<EOS)
#{File.basename($0)} <command> [<args>]

git dirty commands are:
* commit
EOS
  end

  def self.run(command_and_args)
    command = command_and_args.first || "help"
    defined_commands = public_methods(false) - %i(allocate new superclass run)
    if defined_commands.include?(command.to_sym)
      send(command)
    else
      STDERR.puts("sub command not found: sub_command=<#{command}>")
      STDERR.puts
      help
      exit(1)
    end
  end

  def self.commit
    head_commit_message = `git show -q --format=format:%s`
    if COMMIT_MESSAGE_REGEXP.match(head_commit_message)
      exec(*%w(git commit --fixup HEAD))
    else
      exec(*%w(git commit -m), COMMIT_MESSAGE)
    end
  end

  private

  COMMIT_MESSAGE = "dirty commit 001.".freeze
  COMMIT_MESSAGE_REGEXP = /\A(fixup! )?#{Regexp.escape(COMMIT_MESSAGE)}\z/
end

if $0 == __FILE__
  Git::Dirty.run(ARGV)
end
