class Cliffi < Formula
  desc "Tool for calling shared library functions directly from your shell"
  homepage "https://github.com/YSaxon/cliffi"
  url "https://github.com/YSaxon/cliffi/archive/refs/tags/0.9.1-f6d7a12.tar.gz"
  sha256 "be1fb017d13b2f7d4aec1b89f3215692d330618e4a40994b876b2242ec9930bd"
  license "MIT"

  depends_on "cmake" => [:build, :test]
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
