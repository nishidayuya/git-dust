require "spec_helper"

RSpec.describe Git::Dust do
  def chenv(environments = {})
    if block_given?
      saved = chenv(environments)
      begin
        yield
      ensure
        chenv(saved)
      end
    else
      saved = {}
      environments.each do |key, value|
        key = key.to_s
        saved[key] = ENV[key]
        ENV[key] = value.to_s
      end
      return saved
    end
  end

  let(:tmp_path) {
    Pathname(Dir.mktmpdir)
  }

  let(:g) {
    Git.init((tmp_path + "git_working_directory").to_s)
  }

  let(:file1_path) {
    Pathname(g.dir.path) + "a.txt"
  }

  before(:each) do
    g.config("user.name", "git-dust test user")
    g.config("user.email", "anonymous@git-dust.example.org")

    file1_path.write("1\n")
    g.add(all: true)
    g.commit("first import.")

    # only staging
    file1_path.write("2\n")
    g.add(all: true)
  end

  after(:each) do
    tmp_path.rmtree
  end

  describe ".run" do
    describe "empty args" do
      it "invoke help method" do
        allow(Git::Dust).to receive(:help)
        Git::Dust.run([])
        expect(Git::Dust).to have_received(:help).with(nil)
      end
    end

    describe "command arg without optional args" do
      it "invoke specified method" do
        allow(Git::Dust).to receive(:commit)
        Git::Dust.run(%w(commit))
        expect(Git::Dust).to have_received(:commit).with([])
      end
    end
  end

  describe ".commit" do
    describe "empty args" do
      it "commit staging files with commit message" do
        g.chdir do
          expect do
            Git::Dust.commit([])
          end.to change {g.log.count}.by(1)
        end
        expect(g.log.first.message).to eq("git dust commit.")
      end
    end
  end

  describe ".fix" do
    describe "empty args" do
      let(:git_editor_input_path) {
        path = tmp_path + "editor_input"
        path.write("nothing input.\n") # will be overridden
        path
      }

      let(:git_editor_path) {
        path = tmp_path + "editor"
        path.write(<<EOS)
#! /bin/sh

file=$1
cat $file > #{git_editor_input_path}
echo "some commit message." > $file
EOS
        path.chmod(0755)
        path
      }

      it "squash dust commits" do
        g.chdir do
          Git::Dust.commit([])
          file1_path.write("3\n")
          g.add(all: true)
          Git::Dust.commit([])
          chenv(PATH: [BIN_PATH, ENV["PATH"]].join(":"),
                RUBYLIB: [LIB_PATH, ENV["RUBYLIB"]].join(":"),
                GIT_EDITOR: git_editor_path) do
            expect do
              Git::Dust.fix([])
            end.to change {g.log.count}.from(3).to(2)
          end
        end
        expect(g.log.first.message).to eq("some commit message.")
      end
    end
  end

  describe ".edit_rebase_commit_list" do
    describe "rebase_commit_list file path arg" do
      let(:git_editor_input_path) {
        path = tmp_path + "editor_input"
        path.write("nothing input.\n") # will be overridden
        path
      }

      let(:git_editor_path) {
        path = tmp_path + "editor"
        path.write(<<EOS)
#! /bin/sh

file=$1
cat $file > #{git_editor_input_path}
echo "some commit message." > $file
EOS
        path.chmod(0755)
        path
      }

      it "edit rebase commit list" do
        Tempfile.open("git-dust_spec") do |f|
          comments_section = <<EOS
# Rebase 1234567..890abcd onto ef01234
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
EOS
          f.write(<<EOS)
pick 0123456 git dust commit.
pick 7890abc git dust commit.
pick def1234 git dust commit.

#{comments_section}
EOS
          f.close
          Git::Dust.edit_rebase_commit_list([f.path])
          f.open
          expect(f.read).to eq(<<EOS)
pick 0123456 git dust commit.
fixup 7890abc git dust commit.
fixup def1234 git dust commit.

#{comments_section}
EOS
        end
      end
    end
  end
end
