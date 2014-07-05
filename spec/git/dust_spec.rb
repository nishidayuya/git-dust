require "spec_helper"

RSpec.describe Git::Dust do
  describe ".commit" do
    describe "empty args" do
      it "commit staging files with commit message" do
        Dir.mktmpdir do |d|
          tmp_path = Pathname(d)

          g = Git.init(tmp_path.to_s)
          file1_path = tmp_path + "a.txt"
          file1_path.write("1\n")
          g.add(all: true)
          g.commit("first import.")

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
end
