class Cliffi < Formula
  desc "Tool for calling shared library functions directly from your shell"
  homepage "https://github.com/YSaxon/cliffi"
  url "https://github.com/YSaxon/cliffi/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "174e07e96c64b8bacd44a01a4c4fdd7a374402cb4fb5eba01904baafc315add5"
  license "MIT"

  depends_on "cmake" => [:build, :test]
  depends_on "readline" => [:build, :test]
  
  uses_from_macos "libffi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "make", "-C", "build"
    bin.install "build/cliffi"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int a, int b) {
        return a + b;
      }
    EOS
    system ENV.cc, "test.c", "-shared", "-o", "libtest.dylib"
    assert_equal "Function returned: 5", shell_output("#{bin}/cliffi ./libtest.dylib i add 2 3").strip
  end
end
