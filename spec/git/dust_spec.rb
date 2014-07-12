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
end
