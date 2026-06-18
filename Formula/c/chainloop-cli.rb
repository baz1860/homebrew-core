class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.11.tar.gz"
  sha256 "8e5e4e26e688cb2950d7c20e7f84f428990fe97fd60ecaca3fbbecc3d8a9d958"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2d02142d6610c6750bf24a5b9b6f7d948a109212cc2166a092e5360240ac92e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2d02142d6610c6750bf24a5b9b6f7d948a109212cc2166a092e5360240ac92e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2d02142d6610c6750bf24a5b9b6f7d948a109212cc2166a092e5360240ac92e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1303bf950ee5c2a5221a86e354f4b744c43f6405817a9722507bb6af73c19e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa6606b587069106f90044180b5435d5a94799e8bddeca902bc1e6ce4c285eca"
    sha256 cellar: :any,                 x86_64_linux:  "0aaea13a3e8081404cb470395509b8456d2f10011dd2e30aa247ae9b54160ee9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
