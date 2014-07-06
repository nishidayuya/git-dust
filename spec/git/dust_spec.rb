require "spec_helper"

RSpec.describe Git::Dust do
  let(:g) {
    Git.init(Dir.mktmpdir)
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
  end

  after(:each) do
    Pathname(g.dir.path).rmtree
  end

  describe ".commit" do
    describe "empty args" do
      it "commit staging files with commit message" do
        file1_path.write("2\n")
        g.add(all: true)

        g.chdir do
          expect do
            Git::Dust.commit([])
          end.to change {g.log.count}.by(1)
        end
        expect(g.log.first.message).to eq("git dust commit.")
      end
    end
  end
end
