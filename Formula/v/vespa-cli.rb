class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.708.30.tar.gz"
  sha256 "d4bd574ca6b3b4a8ad7ecbf9076d6b36fc6a67ffed59aafc27199377fdcc8560"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b348c5984a43956352f63b8f27cadc13c76a564fa529cec6166501a6f103e855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2075f27249c8543e8c41e2227b1830ea680f83742de2979cde6a762942378bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0675096884ffe8a7d006610378492927324f897abc6682b98fb9aa7f76f30a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad9f082cf663833c3a5ff9daca7c2ad1d441bc2546074218a98a490b99cbcdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17b2279326e7458975cdf18aabb32a4f4cb7982f6f7f432003819801a123d95"
    sha256 cellar: :any,                 x86_64_linux:  "f693eeeb5f70f3a332f164e46da8d651afb32aac0695b2088e6d1f916e8f595a"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
