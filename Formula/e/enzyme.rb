class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.269.tar.gz"
  sha256 "fdda923d86af77d4d4c8f0031455f2edb1d4d5c69494356a40d8c69d10451b45"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a22aa79c6bcf1ee2f76c1cd329f90998a426942ccb202134bd687203460399b0"
    sha256 cellar: :any, arm64_sequoia: "f87a506f8c0b1686f58c89f196fdb425cf17dc7959e2632ff02cb085974cf1f2"
    sha256 cellar: :any, arm64_sonoma:  "2f65c219d1648d2e5dd9ae673174cf292beebc36412f9514b49c4f5580758e81"
    sha256 cellar: :any, sonoma:        "f8f67474185cbfd4308993e9cb7f735496d6f6f3a6bf11647f76838042fc2b70"
    sha256 cellar: :any, arm64_linux:   "58e2cf3e51c06845c2a45fc531c7fb096646f0d2b972d9fcb86aec902eb3efcf"
    sha256 cellar: :any, x86_64_linux:  "462264a32f608ef63f19c9620cb01ea95f6692c6bce64775c95062c8fa721023"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
