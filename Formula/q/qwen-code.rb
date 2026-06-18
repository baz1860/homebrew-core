class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.18.2.tgz"
  sha256 "bccbaed6b086a8f082cfd37cb0d84571888c6d36f2a94be7ea6a73aea468f653"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbf37ef705b5f3a318f362f578c6caab17a053a9f7311b679e4eb188eb4ace22"
    sha256 cellar: :any,                 arm64_sequoia: "dbd4f5c89d47846843c60dda633b17ceea836464413f3c2985c6d8fc155f2d1b"
    sha256 cellar: :any,                 arm64_sonoma:  "dbd4f5c89d47846843c60dda633b17ceea836464413f3c2985c6d8fc155f2d1b"
    sha256 cellar: :any,                 sonoma:        "bef1de14b5c48923337d2c3ffdeb79450daa7f50152308b1bc37d534dde2532b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a01e3385a59da68eb200af72541e0b2bfffb5bd3abd10f28a379b8525cd7f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c0f6c4ae37324fc340bbe1dee9358391433c877c008edec657e30a5cb7edae"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
