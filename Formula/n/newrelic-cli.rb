class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.12.tar.gz"
  sha256 "7235a6aadaecff10447317bbd1531eb10d5b473eef40c806ab1ab763312a178f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da3fe21e905545bbb014324d32e264dbc64200d213f17af9bc3bd8bbf0d55961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985cf664d1041bb220bbfb378a69720d188b8e08e0e369f0961ad5fcbaef9384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f43c47200cd0638b0fff08171a78c8188d2fe73bfe7f9ff75ebd45713440ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "67dfe774555f55071122fe209d6674fefd67ec2c92cad5fa28d341796112d0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f3c9a16ff7f5c86c8f19a203c4d1a23344ed332aeb8e32b0dda1753146c232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3633736124ab86f53c3067aa5ba087a2f0e5eb1e44d91934ac4dbbfb9b19f22"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
