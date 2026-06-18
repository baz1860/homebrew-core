class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.9.0.tgz"
  sha256 "bfa9006edcf0c52c19c3dd1a1fbcfa303ec4508655f55a2965735c1e8f5f465f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82408df97ab29acdcea60e632a880805b9c33a4ec909802f3e15fd0e169c058a"
    sha256 cellar: :any, arm64_sequoia: "ccd98a652e277877823861affd2f2d2175bfa102f15183184b225e4ac2a8fc1f"
    sha256 cellar: :any, arm64_sonoma:  "ccd98a652e277877823861affd2f2d2175bfa102f15183184b225e4ac2a8fc1f"
    sha256 cellar: :any, sonoma:        "d4ed1279c40e5200802edde5b3011efa731c9b3cc29be52740bd6e38015fe68d"
    sha256 cellar: :any, arm64_linux:   "d571ca211347bacb1695235f2abfb6984260aacdc74c236db1d5700fc389f944"
    sha256 cellar: :any, x86_64_linux:  "4e38ae6901f9e7d95d317f6973f99d17c36266f7d18d30fbc51888573c442f7c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
